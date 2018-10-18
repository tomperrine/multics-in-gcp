#
# here's how to get the internal and external IP addresses for all instances
echo "internal address: " `gcloud --format="value(networkInterfaces[0].networkIP)"  compute instances list`
echo "external IP address: " `gcloud --format="value(networkInterfaces[0].accessConfigs[0].natIP)"  compute instances list`

# or for just the known instance
echo just this instance
gcloud --format="value(networkInterfaces[0].networkIP)"  compute instances describe ${INSTANCENAME} --zone ${CLOUDSDK_COMPUTE_ZONE}

