

if [[ `gcloud compute firewall-rules list --filter="name=allow-6180" --format='table(name)' | tail -1 | awk '{print $1}'` != 'allow-6180'   ]]; then
    echo "making firewall rule allow-6180"
    gcloud compute firewall-rules create allow-6180 --allow=tcp:6180 --description="allow inbound 6180 for TELNET"  --source-ranges="0.0.0.0/0"
fi

