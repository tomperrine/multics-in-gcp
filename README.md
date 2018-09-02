# multics-in-gcp

Tools to build and launch Multics in Google Compute

A Project to build and launch Multics in Google Compute, using the SIMH simulator, and the Multics MR12 release.

These scripts use Google gcloud command line SDK, the SIMH dps8m emulator, and Ubuntu to run the Multics operating system in the cloud.

There are two scripts, both of which depend on the environment variables

* launch-multics.sh - this creates the GCP instance, installs Ubuntu
  and copies '5-minute-multics.sh' into the instance and starts it.

* 5-minute-multics.sh - this script is copied into the GCP instance
  and executed. It downloads and builds the "simh" emulator, downloads
  the Multics disk image and configuration files

# Instructions

## Establish your Google cloud account and a project
* Install the Google gcloud SDK
* Create a Google Cloud account, with active billing enabled
* Create a Google project started with the Google components and billing activated
* Create (if necessary) SSH keys and install them into your Google cloud account
* Enable oslogin for your Google cloud project

## Customize your Multics installation

Edit the "configure.ini" file to use your hostname, user names,
etc. See FIXME for details. This script will be used by the emulator
to create your Multics system.

## Set your private ENVIRONMENT variables

Edit the "set-private-data.sh" script to set the needed ENVIRONMENT variables

### Private data - these are specific to your GCP account
* CLOUD_USERNAME - needed since we're going to use Google "OS login"
* PROJ - the name of your Google Compute project

## Set tuning parameters

If desired, set the tuning parameters for the instance - location, size, etc. These are in the "launch-multics.sh" script

Here are the variables and the defaults:

    CLOUDSDK_COMPUTE_ZONE="us-central1-f"
    INSTANCENAME="my-multics"
    MACHINETYPE="f1-micro"
    IMAGEFAMILY="ubuntu-1804-lts"
    IMAGEPROJECT="ubuntu-os-cloud"

## GO!

Run the script:

    $ ./launch-multics.sh

You will see the script create the GCP instance, install and update
Ubuntu, and begin to install all the packages needed for "simh". Then
it will actually install "simh", gather the Multics distibution and
configuration data, and run Multics *twice*.

Note that the system will start from the disk image provided with the
MR12 release. This disk image has already been initialized. If you
don't start from this image, well, you're on your own. Good luck
building Multics from scratch.

The first Multics run does a one-time configuration of the system,
using the information you provided in config.ini. This includes the
system name, and the first user account, which will be created as a
privileged user in the project "SysAdmin". This all updates the disk
image which keeps state between system boots.

The second Multics boot uses the generic boot.init file, and depends
on the system having been configured by the first run. This is the ini
file to be used for all subsequent boots.

# References

    http://swenson.org/multics_wiki/index.php?title=Getting_Started
    https://sourceforge.net/projects/dps8m/files/
    http://swenson.org/multics_wiki/index.php?title=Main_Page
    http://ringzero.wikidot.com/start
    https://github.com/charlesUnixPro/dps8m
