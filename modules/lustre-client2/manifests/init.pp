class lustre-client2 {
    #require cvmfs
    package {"environment-modules":
#              ensure  => '3.2.9c-4.el6.x86_64',
              ensure  => present,
              source  => "ftp://ftp.hosteurope.de/mirror/repo.cloudlinux.com/psbm/6.4/os/x86_64/RPMS/environment-modules-3.2.9c-4.el6.x86_64.rpm",
              alias   => environment-modules,
              before  => Package[openmpi],
              provider=> rpm
            }
    package {"libesmtp":
              ensure  => present,
              #ensure  => '1.0.4-15.el6.x86_64',
              source  => "ftp://mirror.switch.ch/pool/1/mirror/scientificlinux/6.3/x86_64/os/Packages/libesmtp-1.0.4-15.el6.x86_64.rpm",
              alias   => libesmtp,
              before  => Package[openmpi],
              provider=> rpm
            }
    package {"openmpi":
              ensure  => present,
              #ensure  => '1.5.4-2.el6.x86_64',
              source  => "ftp://mirror.switch.ch/pool/1/mirror/scientificlinux/6rolling/x86_64/os/Packages/openmpi-1.5.4-2.el6.x86_64.rpm",
              alias   => openmpi,
              require => Package[libesmtp,environment-modules],
              before  => Package[lustre-tests],
              provider=> rpm
            }
    package {"lustre-client":
              ensure  => present,
              #ensure  => '2.4.1-2.6.32_358.18.1.el6.x86_64', 
              #source  => 'puppet:///modules/lustre-client/lustre-client-2.4.1-2.6.32_358.18.1.el6.x86_64.x86_64.rpm',
              source  => "http://downloads.whamcloud.com/public/lustre/lustre-2.4.1/el6/client/RPMS/x86_64/lustre-client-2.4.1-2.6.32_358.18.1.el6.x86_64.x86_64.rpm",	      	
              alias   => lustre-client,
              require => Package[lustre-module],
              before  => Package[lustre-tests],
              provider=> rpm
	    } 
    package {"lustre-client-modules":
              ensure  => present,
              #source  => 'puppet:///modules/lustre-client/lustre-client-modules-2.4.1-2.6.32_358.18.1.el6.x86_64.x86_64.rpm',
              #ensure  => '2.4.1-2.6.32_358.18.1.el6.x86_64',
              source  => "http://downloads.whamcloud.com/public/lustre/lustre-2.4.1/el6/client/RPMS/x86_64/lustre-client-modules-2.4.1-2.6.32_358.18.1.el6.x86_64.x86_64.rpm",
              alias   => lustre-module,
              before => Package[lustre-client],
              provider => rpm
	    }
    package {"lustre-client-debuginfo":
              ensure  => present,
              #source  => 'puppet:///modules/lustre-client/lustre-client-debuginfo-2.4.1-2.6.32_358.18.1.el6.x86_64.x86_64.rpmi',
              #ensure  => '2.4.1-2.6.32_358.18.1.el6.x86_64',
              source  => "http://downloads.whamcloud.com/public/lustre/lustre-2.4.1/el6/client/RPMS/x86_64/lustre-client-debuginfo-2.4.1-2.6.32_358.18.1.el6.x86_64.x86_64.rpm",
              alias   => lustre-debuginfo,
              require => Package[lustre-module],
              provider => rpm
	    }
    package {"lustre-client-tests":
              ensure  => present,
              #source  => 'puppet:///modules/lustre-client/lustre-client-tests-2.4.1-2.6.32_358.18.1.el6.x86_64.x86_64.rpm',
              #ensure  => '2.4.1-2.6.32_358.18.1.el6.x86_64',
              source  => "http://downloads.whamcloud.com/public/lustre/lustre-2.4.1/el6/client/RPMS/x86_64/lustre-client-tests-2.4.1-2.6.32_358.18.1.el6.x86_64.x86_64.rpm",
              alias   => lustre-tests,
              require => Package[lustre-debuginfo],
              provider => rpm
            }
#    package {"lustre-io":
#              ensure  => present,
#              source  => "http://downloads.whamcloud.com/public/lustre/lustre-2.4.1/el6/client/RPMS/x86_64/lustre-iokit-1.4.0-1.noarch.rpm",
#              alias   => lustre-io,
#              require => Package[lustre-debuginfo]
#            }

    file { 'lustre.conf' :
              ensure  => present,
              path    => '/etc/modprobe.d/lustre.conf',
              content => 'options lnet networks=o2ib',
              mode    => 0644,
              require => Package[lustre-tests]    
         }

    exec { 'modprobe lustre':
    	      command   => '/sbin/modprobe lustre',
    	      subscribe => File['lustre.conf'],
              #unless    => 'output=$(/bin/uname -r);[ "$output" == "2.6.32-358.el6.x86_640" ];',
              #onlyif    => "[ `/bin/uname -r` == '2.6.32-358.18.1.el6.x86_64' ]",
              alias     => modprobe,
              require   => Package[lustre-tests],
              onlyif    =>  '/usr/bin/test `/bin/uname -r` = "2.6.32-358.18.1.el6.x86_64"',
              #unless    =>  '/usr/bin/test `/sbin/service lustre status` = "partial"'
         }
    
    exec { "mkdir /lustre":
              command   => "/bin/mkdir /lustre",
              require   => File['lustre.conf'],
              before    => Exec[modprobe],
              creates   => '/lustre'
              #unless    => "/bin/ls /lustre 2>/dev/null"  
         } 
    exec { 'mount lustre':
              command   =>  '/bin/mount -t lustre 192.168.1.254@o2ib:/lustre /lustre',
              require   => Exec[modprobe],
              onlyif    => '/usr/bin/lfs df -h > /dev/null 2>&1' 
	 }        
}

