#include exportfact
node default {
  include nis
  include torque::mom
  include hba
  #include cvmfs-close
  include cvmfs
  include lustre-client
  #exportfact::import { 'server': }
}

node a061{
  #include torque::server
  #include hba
  #include cvmfs-close
  include lustre-client2

  #exportfact::export { 'server_ipaddress_ib0':
  #value => $ipaddress_ib0,
  #category => "server"
  #}
}

