#
# network config data
#
# NOTE: this is not idempotent, can only be done once so check for existance first


if [[ `gcloud compute firewall-rules list --filter="name=allow-6180" --format='table(name)' | tail -1 | awk '{print $1}'` != 'allow-6180'   ]]; then
    echo "making firewall rule allow-6180"
    gcloud compute firewall-rules create allow-6180 --allow=tcp:6180 --description="allow inbound 6180 for TELNET"  --source-ranges="0.0.0.0/0"
fi


#
# here's how to get the internal and external IP addresses for all instances
echo "internal address: " `gcloud --format="value(networkInterfaces[0].networkIP)"  compute instances list`
echo "external IP address: " `gcloud --format="value(networkInterfaces[0].accessConfigs[0].natIP)"  compute instances list`

# or for just the known instance
echo just this instance
gcloud --format="value(networkInterfaces[0].networkIP)"  compute instances describe ${INSTANCENAME} --zone ${CLOUDSDK_COMPUTE_ZONE}


