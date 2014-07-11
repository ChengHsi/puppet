class nis::params {
  #$hostname = hiera("nis::params::hostname", $::fqdn)
  $gateway = hiera("nis::params::gateway", '192.168.1.254')
  $nisdomain = hiera("nis::params::nisdomain", 'cluster2')
  $server_ipaddress_ib0 = hiera("nis::params::server_ipaddress_ib0", '192.168.1.61')
}
