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
  # Apple OS X
  elif [ -f "/usr/bin/sw_vers" ];
  then
    platform="mac_os_x"
  elif [ -f "/etc/release" ];
  then
    platform="solaris2"
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

install_curl() {
  echo "installing curl..."
  case "$(detect_platform)" in
    "ubuntu" )
      apt-get -y install curl
      ;;
    "debian" )
      apt-get -y install curl
      ;;
    "el" )
      yum -y install curl
      ;;
    "fedora" )
      yum -y install curl
      ;;
    "suse" )
      yast -i curl
      ;;
    "sles" )
      yast -i curl
      ;;
    *)
      echo "sorry, I don't have a bootstrap for this platform"
      exit 1
      ;;
  esac
}

exists curl || install_curl

# install chef-solo
curl -L https://www.opscode.com/chef/install.sh | bash
