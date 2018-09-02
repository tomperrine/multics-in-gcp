#!/bin/sh

# this will copied onto and run on the host that's being installed
# all that should be there is the base OS (must have git client)

# must run as root, obviously

set -v

date
# Begin with the Google standard Ubuntu 18.04 LTS (not the minimal)
#
# use a smaller instance - remember, this can run on a Raspberry Pi2 as well
# as the original (original 6180?) hardware
# time to run this script, except Multics boot...
# f1-micro (1 vCPU, 0.6 GB memory):
#    real    9m7.891s
#    user    6m10.436s
#    sys     1m23.556s
# time to boot Multics: ~30 sec
# g1-small (1 vCPU, 1.7 GB memory):
#    real    3m58.415s
#    user    2m11.966s
#    sys     0m24.057s
# time to boot multics: < 20 sec

# if you don't do this then a lot of the application packages won't install properly
# beside, its always a good idea to update+upgrade immediately after installation
sudo apt-get --yes update
sudo apt-get --yes upgrade

# you will need these packages to build the emulator
sudo apt-get --yes install build-essential libtool-bin m4 automake clang unzip
# clang is needed to build dps8
# unzip is needed to unzip the Multics image

# install this libuv - not sure why, but it's from the Ubuntu readme
# the system one would be
# sudo apt-get install libuv1
#
cd
git clone https://github.com/libuv/libuv.git
cd libuv
sh autogen.sh
./configure
make
sudo make install

# otherwise the DPS8 build will fail at link time on not
# finding the libuv we just built and installed (into /usr/lib/local)
sudo ldconfig


# time to build the emulator
cd
git clone git://git.code.sf.net/p/dps8m/code dps8m-code
cd dps8m-code
make
# you can run the emulator here with no args to verify that
# it at least compiled correctly
#cd
#../dps8m-code/src/dps8/dps8

# OK emulator smoke test OK, let's get some Multics
cd
wget https://sourceforge.net/projects/dps8m/files/QuickStart_MR12.6f.zip
#wget https://sourceforge.net/projects/dps8m/files/QuickStart_MR12.6e_rc7a1/QuickStart_MR12.6e_rc7a1.zip
unzip QuickStart_MR12.6f

# you must be in the same dir as the root disk file, or it will begin to create one
# which takes about an infinite amount of time
# so use the one provided
cd QuickStart_MR12.6f
#
# we want our configure.ini for the first boot, to add all the accounts we need
# it will add accounts, quota, etc and then halt. This leaves behind a disk image
# with all our cusstomizations - after that, use the stock .ini
cp ~/configure.ini .
# watch in amazement as Multics boots and configures itself
~/dps8m-code/src/dps8/dps8 configure.ini
# and shuts itself down

date

# now start the system with the proper ini file for normal operations
~/dps8m-code/src/dps8/dps8 MR12.6f_boot.ini


