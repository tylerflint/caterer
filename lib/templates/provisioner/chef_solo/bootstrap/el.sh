# install curl
echo "ensure curl exists..."
command -v curl &>/dev/null || yum -y install curl

# install rsync
echo "ensure rsync exists..."
command -v rsync &>/dev/null || yum -y install rsync

# install chef
echo "bootstrapping chef..."
curl -L https://www.opscode.com/chef/install.sh | bash