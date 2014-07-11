class torque::mom::install{
  file { '/opt/hpc_soft/':
    ensure => "directory",
    before => mount['/opt/hpc_soft'],
  }
  mount { '/opt/hpc_soft':
    device  => "a061:/opt/hpc_soft",
    fstype  => "nfs",
    ensure  => "mounted",
    options => "defaults",
    atboot  => "true",
    before  => exec['torque-mom', 'torque-clients', 'copy'] 
    #before  => package['torque-mom','torque-clients']
  }
  #package {'torque-mom':
  #  ensure => present,
  #  source => '/opt/hpc_soft/torque-2.5.9/torque-package-mom-linux-x86_64.sh'
  #}
  
  #package {'torque-clients':
  #  ensure => present,
  #  source => '/opt/hpc_soft/torque-2.5.9/torque-package-clients-linux-x86_64.sh'
  #}
  exec {'copy':
    command => "/bin/cp /opt/hpc_soft/torque-2.5.9/contrib/init.d/pbs_mom /etc/init.d/",
    before => exec['torque-mom', 'torque-clients'],
    unless => "/bin/ls /etc/init.d/pbs_mom 2>/dev/null"
  }

  exec {'torque-mom':
    command => "/bin/sh /opt/hpc_soft/torque-2.5.9/torque-package-mom-linux-x86_64.sh --install", 
    before  => service['pbs_mom'],
    unless  => "/sbin/service pbs_mom status 2>/dev/null" 
  }
  
  exec {'torque-clients':
    command => "/bin/sh /opt/hpc_soft/torque-2.5.9/torque-package-clients-linux-x86_64.sh --install",
    before  => service ['pbs_mom'],
    unless  => "/sbin/service pbs_mom status 2>/dev/null" 
  }
}

