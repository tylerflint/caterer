#!/bin/bash

# this script will:
# 1- detect a platform
# 2- install curl
# 3- download and run the chef-solo installer

# Check whether a command exists
exists() {
  if command -v $1 &>/dev/null
  then
    return 0
  else
    return 1
  fi
}

detect_platform() {
  local platform=""
  if [ -f "/etc/lsb-release" ];
  then
    platform=$(grep DISTRIB_ID /etc/lsb-release | cut -d "=" -f 2 | tr '[A-Z]' '[a-z]')
  elif [ -f "/etc/debian_version" ];
  then
    platform="debian"
  elif [ -f "/etc/redhat-release" ];
  then
    platform="el"
  elif [ -f "/etc/system-release" ];
  then
    platform=$(sed 's/^\(.\+\) release.\+/\1/' /etc/system-release | tr '[A-Z]' '[a-z]')
    # amazon is built off of fedora, so act like RHEL
    if [ "$platform" = "amazon linux ami" ];
    then
      platform="el"
    fi
  elif [ -f "/usr/bin/sw_vers" ];
  then
    platform="mac_os_x"
  elif [ -f "/etc/release" ];
  then
    if [[ -n $(cat /etc/release | grep "SmartOS") ]]; then
      platform="smartos"
    else
      platform="solaris2"
    fi
  elif [ -f "/etc/SuSE-release" ];
  then
    if grep -q 'Enterprise' /etc/SuSE-release;
    then
        platform="sles"
    else
        platform="suse"
    fi
  fi
  echo $platform
}

install() {
  echo "installing $1..."
  case "$(detect_platform)" in
    "ubuntu" )
      apt-get -y --force-yes install $1
      ;;
    "debian" )
      apt-get -y --force-yes install $1
      ;;
    "el" )
      yum -y install $1
      ;;
    "fedora" )
      yum -y install $1
      ;;
    "suse" )
      yast -i $1
      ;;
    "sles" )
      yast -i $1
      ;;
  esac
}

bootstrap() {
  echo "bootstrapping chef..."
  case $(detect_platform) in
    "smartos" )
      # I don't know how legit this is :/
      echo "downloading fatclient from Ben Rockland library..."
      wget -q -P /tmp http://cuddletech.com/smartos/Chef-fatclient-SmartOS-10.14.2.tar.bz2 
      cd /; tar -xjf /tmp/Chef-fatclient-SmartOS-10.14.2.tar.bz2
      # make an executable link
      mkdir -p /opt/local/bin
      ln -s /opt/local/bin/chef-solo /opt/chef/bin/chef-solo 
      # cleanup
      rm -f /tmp/Chef-fatclient-SmartOS-10.14.2.tar.bz2
      ;;
    *)
      curl -L https://www.opscode.com/chef/install.sh | bash
      ;;
  esac
}

exists curl || install curl

exists rsync || install rsync

# install chef-solo
exists chef-solo || bootstrap
