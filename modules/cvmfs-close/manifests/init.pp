class cvmfs-close{
    file{'cvmfs-key':
        path   => '/etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM',
        ensure => present,
        source => 'puppet:///modules/cvmfs/RPM-GPG-KEY-CernVM',
    }
    yumrepo {'cernvm':
        baseurl => 'http://cvmrepo.web.cern.ch/cvmrepo/yum/cvmfs/EL/$releasever/$basearch/',
        gpgcheck=> 1,
        enabled => 1,
        gpgkey  => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CernVM',
        protect => 1,
        require => File[cvmfs-key],
    } 
    package { 'cvmfs':
        ensure  => installed,
        require => Yumrepo['cernvm'],
    }
    file {'/etc/cvmfs/config.d/grid.cern.ch':
        ensure  => 'link',
        target  => '/opt/hpc_soft/grid/grid.cern.ch',
        require=> Package['cvmfs'],
        before  => File['/etc/auto.master'],
    }
    file {'/etc/cvmfs/default.local':
        ensure  => 'link',
        target  => '/opt/hpc_soft/grid/default.local',
        require=> Package['cvmfs'],
        before  => File['/etc/auto.master'],
    }
    file {'/etc/profile.d/grid_env.sh':
        ensure  => 'link',
        target  => '/opt/hpc_soft/grid/grid_env.sh',
        require => Package['cvmfs'],
        before  => File['/etc/auto.master'],
    }
    file{ '/etc/auto.master':
        ensure => present,
        #source => 'puppet:///modules/cvmfs/files/auto.master',
        source => 'puppet:///modules/cvmfs-close/auto.master',
        notify => Service['autofs'],
        require=> Package['cvmfs']
    }

    service{ 'autofs':
        ensure    => running,
        subscribe => File['/etc/auto.master']
    }
}
