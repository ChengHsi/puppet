# takes the module_name as argument, make neccessary folders for it
mkdir -p /etc/puppet/modules/$1/manifests
mkdir -p /etc/puppet/modules/$1/files
mkdir -p /etc/puppet/modules/$1/lib
touch /etc/puppet/modules/$1/manifests/init.pp
