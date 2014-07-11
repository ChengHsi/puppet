Facter.add('mom_status') do
  setcode do
    Facter::Util::Resolution.exec('/sib/service pbs_mom status')
  end
end
