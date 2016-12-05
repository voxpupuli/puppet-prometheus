class prometheus::daemon::install (
  $install_method,
  $daemon_name,
  $version,
  $download_extension,
  $os,
  $arch,
  $real_download_url,
  $bin_dir,
  $notify_service,
  $package_name,
  $package_ensure,
  $manage_user,
  $user,
  $install_method,
  $extra_groups,
  $group,
  $manage_group,
  )
{

  case $install_method {
    'url': {
      include staging
      $staging_file = "${daemon_name}-${version}.${download_extension}"
      $binary = "${::staging::path}/${daemon_name}-${version}.${os}-${arch}/${daemon_name}"
      staging::file { $staging_file:
        source => $real_download_url,
      } ->
      staging::extract { $staging_file:
        target  => $::staging::path,
        creates => $binary,
      } ->
      file {
        $binary:
          owner => 'root',
          group => 0, # 0 instead of root because OS X uses "wheel".
          mode  => '0555';
        "${bin_dir}/${daemon_name}":
          ensure => link,
          notify => $notify_service,
          target => $binary,
      }
    }
    'package': {
      package { $package_name:
        ensure => $package_ensure,
      }
      if $manage_user {
        User[$user] -> Package[$package_name]
      }
    }
    'none': {}
    default: {
      fail("The provided install method ${install_method} is invalid")
    }
  }
  if $manage_user {
    ensure_resource('user', [ $user ], {
      ensure => 'present',
      system => true,
      groups => $extra_groups,
    })

    if $manage_group {
      Group[$group] -> User[$user]
    }
  }
  if $manage_group {
    ensure_resource('group', [ $group ], {
      ensure => 'present',
      system => true,
    })
  }
}
