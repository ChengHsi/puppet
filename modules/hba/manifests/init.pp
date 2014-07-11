class hba{
    #notify {"This is HBA":}
    file{ '/etc/ssh/shosts.equiv':
            owner => root,
            group => root,
            ensure => present,
            #source => 'puppet:///modules/cvmfs/files/auto.master',
            source => 'puppet:///modules/hba/shosts.equiv',
            #notify => Service['autofs'],
            #require=> Package['cvmfs']
        }

    file{ '/etc/ssh/ssh_config':
            owner => root,
            group => root,
            ensure => present,
            #source => 'puppet:///modules/cvmfs/files/auto.master',
            source => 'puppet:///modules/hba/ssh_config',
            #notify => Service['autofs'],
            #require=> Package['cvmfs']
        }

    file{ '/etc/ssh/ssh_known_hosts':
            owner => root,
            group => root,
            ensure => present,
            #source => 'puppet:///modules/cvmfs/files/auto.master',
            source => 'puppet:///modules/hba/ssh_known_hosts',
            #notify => Service['autofs'],
            #require=> Package['cvmfs']
        }

    file{ '/etc/ssh/sshd_config':
            owner => root,
            group => root,
            ensure => present,
            #source => 'puppet:///modules/cvmfs/files/auto.master',
            source => 'puppet:///modules/hba/sshd_config',
            #notify => Service['autofs'],
            #require=> Package['cvmfs']
    }
}
