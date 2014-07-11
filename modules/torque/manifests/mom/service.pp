class torque::mom::service(
    $ensure = $torque::params::mom_service_ensure,
    $enable = $torque::params::mom_service_enable,
)   inherits torque::params {
    service { 'pbs_mom':
        ensure     => $ensure,
        enable     => $enable,
        hasrestart => true,
        hasstatus  => true,
        #require    => exec['torque-mom', 'torque-clients'],
        #subscribe  => File['/etc/torque/mom/config'],
  }
}
