class nis(
  $serverip  = $nis::params::serverip,
  $nisdomain = $nis::params::nisdomain,
  ) inherits nis::params {
  file {'/etc/sysconfig/network':
    ensure  => 'present',
    content => template("${module_name}/network.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644', 
  }

  file {'/etc/nsswitch.conf':
    ensure  => 'present',
    source  => 'puppet:///modules/nis/nsswitch.conf',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file {'/etc/yp.conf':
    ensure  => 'present',
    content => template("${module_name}/ypconf.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify => service['ypbind'],
  }

  service {'ypbind':
    ensure => running,
  #  before => notify['warning'],
  }

  #notify {'warning':
  #  message=> "error!! somethin wrong with ypbind",
  #  unless => "id twgrid001 > /dev/null 2>&1",
  #}
  
  mount { '/home':
    device  => "a061:/home",
    fstype  => "nfs",
    ensure  => "mounted",
    options => "defaults",
    atboot  => "true",
  } 

}
