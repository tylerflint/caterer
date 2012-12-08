
package 'build-essential'
package 'whois'
chef_gem 'ruby-shadow'

[['bert', 'password'], ['ernie', 'password'], ['tylerflint', 'password']].each do |u, pass|
  user u do
    supports :manage_home => true
    home "/home/#{u}"
    password `echo #{pass} | mkpasswd -s -m sha-512`.chomp
  end
end

