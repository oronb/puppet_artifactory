#!/usr/bin/env ruby
$architecture = Facter["architecture"].value()
Facter.add(:java_home_7) do
  confine :kernel  => :linux
  setcode do
    distid = Facter.value(:osfamily)
    case distid
    when 'RedHat'
	Facter::Util::Resolution.exec("find / -name 'java-1.7.0-openjdk*#$architecture' | grep /usr/lib/jvm/")
    when 'Debian'
    end
  end
end
