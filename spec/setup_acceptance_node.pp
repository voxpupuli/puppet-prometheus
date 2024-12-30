if $facts['os']['family'] == 'Debian' {
  package { 'apt-transport-https':
    ensure => 'installed',
  }
}
