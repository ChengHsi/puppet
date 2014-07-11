Facter.add("ldd") do
  setcode do
    Facter::Util::Resolution.exec('/usr/bin/ldd /bin/ls|/bin/grep libselinux')
  end
end
