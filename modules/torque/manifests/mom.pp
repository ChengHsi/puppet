class torque::mom {
  if ! defined(Service['pbs_mom']){
    class { 'torque::mom::install':}
  }
  class { 'torque::mom::service':}
}
