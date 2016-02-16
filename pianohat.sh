#!/bin/bash

# productname="Piano HAT" # the name of the product to install
# scriptname="pianohat" # the name of this script
# localdir="pianohat" # the name of the dir for copy of examples
# gitreponame="piano-hat" # the name of the git project repo
# docdir="$gitreponame/documentation" # subdirectory of examples in repo
# examplesdir="$gitreponame/examples" # subdirectory of examples in repo

# CONFIG=/boot/config.txt
# BLACKLIST=/etc/modprobe.d/raspi-blacklist.conf
# LOADMOD=/etc/modules
# DEVICE_TREE=true

# success() {
#     echo "$(tput setaf 2)$1$(tput sgr0)"
# }
#
# warning() {
#     echo "$(tput setaf 1)$1$(tput sgr0)"
# }

# raspbian_check() {
#     IS_RASPBIAN=$(cat /etc/*-release | grep "Raspbian")
#
#     if [[ "" == $IS_RASPBIAN ]]; then
#         false
#     else
#         true
#     fi
# }

# if ! raspbian_check; then
#     warning "Warning!"
#     echo "Please only run this script on Raspbian on your Raspberry Pi"
#     exit 1
# fi

# if [ $EUID -ne 0 ]; then
#     USER_HOME=$(getent passwd $USER | cut -d: -f6)
# else
#     USER_HOME=$(getent passwd $SUDO_USER | cut -d: -f6)
# fi

# WORKING_DIR=$USER_HOME/Pimoroni
#
# if ! [ -d $WORKING_DIR ]; then
#         mkdir $WORKING_DIR
# fi
#
# if [ examplesdir != "na" ]; then
#
#     if ! [ -d $WORKING_DIR/$localdir ]; then
#         echo ""
#         echo "Downloading $productname examples..."
#         export TMPDIR=`mktemp -d /tmp/pimoroni.XXXXXX`
#         cd $TMPDIR
#         git clone https://github.com/pimoroni/$gitreponame
#         cd $WORKING_DIR
#         mkdir $localdir
#         cp -R $TMPDIR/$examplesdir/* $WORKING_DIR/$localdir/
#         rm -rf $TMPDIR
#         success "Examples copied to $WORKING_DIR/$localdir/"
#     else
#         echo ""
#         mv $WORKING_DIR/$localdir $WORKING_DIR/$localdir-backup
#         echo "Updating $productname examples..."
#         export TMPDIR=`mktemp -d /tmp/pimoroni.XXXXXX`
#         cd $TMPDIR
#         git clone https://github.com/pimoroni/$gitreponame
#         cd $WORKING_DIR
#         mkdir $localdir
#         cp -R $TMPDIR/$examplesdir/* $WORKING_DIR/$localdir/
#         rm -rf $TMPDIR
#         warning "I backed up the examples to $localdir-backup, just in case you've changed anything!"
#         success "Examples copied to $WORKING_DIR/$localdir/"
#     fi
# fi
