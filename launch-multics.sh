#!/bin/bash

# given a GCP, etc account and the SDK on the install-from host, build and install a new server

# set the needed enviropnment vars
. ../cloud-configuration/set-cloud-configuration.sh

. ./instance-name.sh

# launch the instance - assume it does NOT already exist
# on a tiny instance, this will take up to 10 minutes to create the instance,
# install Ubutnu and apply all patches
# it is faster on a larger instance
echo "launching instance, patching (can take up to 10 minutes on a tiny)..."
../create-simple-google-instance/create-instance.sh

# put the main install script on the host and run it
# also put the customized Multics configure.ini there for use at Multics boot time
# dont return here until the OS is running, all packages have been installed and
# Multics has started (and halted)

# this is the configuration script that is customized to include any
# user accounts, projects, hostname, etc for your site
# EDIT configure.ini BEFORE running this script
gcloud compute scp configure.ini ${CLOUD_USERNAME}@${INSTANCENAME}: --project ${PROJ} --zone ${CLOUDSDK_COMPUTE_ZONE}

# this script will update Ubuntu, install all the packages needed to build SIMH
# then it will biuld SIMH, boot Multics and run the initial configuration script

gcloud compute scp 5-minute-multics.sh ${CLOUD_USERNAME}@${INSTANCENAME}: --project ${PROJ} --zone ${CLOUDSDK_COMPUTE_ZONE}
gcloud compute ssh ${CLOUD_USERNAME}@${INSTANCENAME} --project ${PROJ} --zone ${CLOUDSDK_COMPUTE_ZONE} -- chmod +x 5-minute-multics.sh

gcloud compute ssh ${CLOUD_USERNAME}@${INSTANCENAME} --project ${PROJ} --zone ${CLOUDSDK_COMPUTE_ZONE} -- './5-minute-multics.sh'


exit
