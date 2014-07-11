#take a file of nodelist as argument, install puppet and epel.repo
while read line
do 
    ssh -n $line "
    hostname 
    yum --disablerepo=epel -y -d 1 -e 1 install ca-certificates
    if rpm -qa | grep -q epel; then
        echo 'epel already installed'
    else
        wget http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
        rpm -i --quiet epel-release-6-8.noarch.rpm
        rm epel-release-6-8.noarch.rpm*
    fi
    yum -y install puppet
    " 
    
done < $1
