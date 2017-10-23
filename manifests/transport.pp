# @summary Configures Sensu transport
#
# Configure Sensu Transport
#
class sensu::transport {

  if $::sensu::transport_type != 'redis' and $::sensu::transport_type != 'snssqs' {
    $ensure = 'absent'
  } else {
    $ensure = 'present'
  }
  notify { "transport type: $::sensu::transport_type": }

  $transport_type_hash = {
    'transport' => {
      'name'               => $::sensu::transport_type,
      'reconnect_on_error' => $::sensu::transport_reconnect_on_error,
    },
  }

  file { "${sensu::conf_dir}/transport.json":
    ensure  => $ensure,
    owner   => 'sensu',
    group   => 'sensu',
    mode    => '0440',
    content => inline_template('<%= JSON.pretty_generate(@transport_type_hash) %>'),
    notify  => $::sensu::check_notify,
  }
}
