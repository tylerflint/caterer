# download and install fatclient
[[ -d /opt/chef ]] || (cd /; curl -k -s -S https://s3.amazonaws.com/packages.pagodabox.com/tar/smartos/chef/chef-fatclient.tar.bz2 | bzcat | tar -xf -)

# create symlink for chef-solo
[[ -d /opt/local/bin ]] || mkdir -p /opt/local/bin
[[ -f /opt/local/bin/chef-solo ]] || ln -s /opt/chef/bin/chef-solo /opt/local/bin/chef-solo
