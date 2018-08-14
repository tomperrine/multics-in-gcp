# multics-in-gcp
build and launch Multics in Google Compute

A Project to build and launch Multics in Google Compute, using the SIMH simulator, and the Multics MR12 release.

It uses Google gcloud command line SDK, SIMH, Ubuntu, etc

It requires some private data such as Google account information, hostname, etc.

0. Before you start, you need:
0.1 Google's gcloud SDK installed
0.2 a Google Cloud account, with active billing enabled
0.3 a project started with the Google components activated
0.4 SSH keys established on your local machine, and with Google
0.5 oslogin enabled



1. Gather private information
1.1 CLOUD_USERNAME for oslogin
1.2 Google Project name

2. Gather "public" data - anything not sensitive
2.1 Which Google zone to use
2.2 instance size
2.3 OS/image

3. create-mailserver.sh - Use glcoud to create the instance

4. os-and-ansible.sh
4.1 update the OS
4.2 run ansible to install and configure all the needed packages


References

http://swenson.org/multics_wiki/index.php?title=Getting_Started
https://sourceforge.net/projects/dps8m/files/
http://swenson.org/multics_wiki/index.php?title=Main_Page
http://ringzero.wikidot.com/start
https://github.com/charlesUnixPro/dps8m
