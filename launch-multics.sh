#!/bin/bash

# given a GCP, etc account and the SDK on the install-from host, build and install a new server

# Pre-rews:
# Billing

. ./set-private-data.sh

# If you don't use ssh-add to add your key to your active ssh-agent
# you're going to be typing your passphrase an awful lot


# set specifics for this instance
# this file sets all the non-sensitive customizations
# anything in here would be the same for anyone using this to install this type of server

# pick a region
export CLOUDSDK_COMPUTE_ZONE="us-central1-f"

# set information for the instance we will create
INSTANCENAME="my-multics-test"
MACHINETYPE="f1-micro"
IMAGEFAMILY="ubuntu-1804-lts"
IMAGEPROJECT="ubuntu-os-cloud"
# END OF CONFIG DATA

#
# network config data
#
# NOTE: this is not idempotent, can only be done once so check for existance first


if [[ `gcloud compute firewall-rules list --filter="name=allow-6180" --format='table(name)' | tail -1 | awk '{print $1}'` != 'allow-6180'   ]]; then
    echo "making firewall rule allow-6180"
    gcloud compute firewall-rules create allow-6180 --allow=tcp:6180 --description="allow inbound 6180 for TELNET"  --source-ranges="0.0.0.0/0"
fi

#
# create the instance
#
gcloud compute instances create ${INSTANCENAME} --machine-type=${MACHINETYPE} --image-family=${IMAGEFAMILY} --image-project=${IMAGEPROJECT}
gcloud compute instances get-serial-port-output ${INSTANCENAME}

# add the oslogin option so I don't need to manage SSH keys
gcloud compute instances add-metadata ${INSTANCENAME} --metadata enable-oslogin=TRUE

#
# it can take some time, and sometimes(?) the create returns much faster than expected, or the system
# takes a long time to boot and get to the SSH server, so wait for it to be READY
SSHRETURN="dummy"
while [[ "RUNNING" != ${SSHRETURN} ]]; do
    SSHRETURN=`gcloud compute instances describe ${INSTANCENAME} | grep status: | awk -F\  ' {print $2}' `
    sleep 5
#    echo sshreturn ${SSHRETURN}
done
#echo ${SSHRETURN}

#
# now wait until the SSH server is running (we get a response without a timeout)
SSHRETURN=255
while [[ ${SSHRETURN} -ne 0 ]]; do
    gcloud compute ssh ${CLOUD_USERNAME}@${INSTANCENAME} --project ${PROJ} --zone ${CLOUDSDK_COMPUTE_ZONE} -- hostname
    SSHRETURN=$?
    sleep 3
done

#
# here's how to get the internal and external IP addresses for all instances
echo "internal address: " `gcloud --format="value(networkInterfaces[0].networkIP)"  compute instances list`
echo "external IP address: " `gcloud --format="value(networkInterfaces[0].accessConfigs[0].natIP)"  compute instances list`

# or for just the known instance
echo just this instance
gcloud --format="value(networkInterfaces[0].networkIP)"  compute instances describe ${INSTANCENAME} --zone ${CLOUDSDK_COMPUTE_ZONE}


# put the main install script on the host and run it
# also put the customized Multics configure.ini there for use at Multics boot time
# dont return here until the OS is running, all packages have been installed and
# Multics has started (and halted)
gcloud compute scp configure.ini ${CLOUD_USERNAME}@${INSTANCENAME}: --project ${PROJ} --zone ${CLOUDSDK_COMPUTE_ZONE}

gcloud compute scp 5-minute-multics.sh ${CLOUD_USERNAME}@${INSTANCENAME}: --project ${PROJ} --zone ${CLOUDSDK_COMPUTE_ZONE}
gcloud compute ssh ${CLOUD_USERNAME}@${INSTANCENAME} --project ${PROJ} --zone ${CLOUDSDK_COMPUTE_ZONE} -- chmod +x 5-minute-multics.sh

gcloud compute ssh ${CLOUD_USERNAME}@${INSTANCENAME} --project ${PROJ} --zone ${CLOUDSDK_COMPUTE_ZONE} -- './5-minute-multics.sh'


exit
