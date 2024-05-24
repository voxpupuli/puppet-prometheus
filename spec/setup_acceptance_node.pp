file_line { '/etc/hosts-squid':
  path => '/etc/hosts',
  line => "${facts['squid_ip']} squid",
}

if $facts['os']['family'] == 'Debian' {
  package { 'apt-transport-https':
    ensure => 'installed',
  }
}
