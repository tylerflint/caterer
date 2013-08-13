# remove fat-client
[[ -d /opt/chef ]] && rm -rf /opt/chef

# drop symlink
[[ -f /opt/local/bin/chef-solo ]] && rm -f /opt/local/bin/chef-solo