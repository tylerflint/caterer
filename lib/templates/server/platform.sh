platform=""
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
  elif [[ -n $(cat /etc/release | grep "OmniOS") ]]; then
    platform="omnios"
  elif [[ -n $(cat /etc/release | grep "OpenIndiana") ]]; then
    platform="openindiana"
  elif [[ -n $(cat /etc/release | grep "OpenSolaris") ]]; then
    platform="opensolaris"
  elif [[ -n $(cat /etc/release | grep "Oracle Solaris") ]]; then
    platform="oracle_solaris"
  elif [[ -n $(cat /etc/release | grep "Solaris") ]]; then
    platform="solaris2"
  elif [[ -n $(cat /etc/release | grep "NexentaCore") ]]; then
    platform="nexentacore"
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