#!/bin/bash
DISTRIBUTION_NAME=`cat /etc/os-release | grep PRETTY_NAME`
cd `dirname $0`
UTILS_DIR=`pwd`

DISTRIBUTION="unknown"
case "$DISTRIBUTION_NAME" in
    *Debian*)
        DISTRIBUTION="debian"
        ;;
    *Ubuntu*)
        DISTRIBUTION="debian"
        ;;
    *CentOS*)
        DISTRIBUTION="centos"
        ;;
esac
export DISTRIBUTION="$DISTRIBUTION"
echo "preparing the system ..."
echo "distribution: $DISTRIBUTION"
echo "utils dir: $UTILS_DIR"
if [ "$DISTRIBUTION" = "unknown" ]; then
    echo "ERROR: unknown distribution"
    exit 1
fi

echo " "
echo " "
echo "*** INSTALLING PACKAGES ***"
cd $UTILS_DIR
case "$DISTRIBUTION" in
    debian)
        ./debian_install_packages.sh
        ;;
    centos)
        ./centos_install_packages.sh
        ;;
esac

echo " "
echo " "
echo "*** SYSTEM SETUP DONE ***"
echo " "
