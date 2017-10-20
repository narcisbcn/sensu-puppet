# @summary Sets the Sensu sensu config
#
# Sets the Sensu sensu config
#
class sensu::sensu::config {

  if $::sensu::_purge_config and !$::sensu::server and !$::sensu::client and !$::sensu::enterprise and $::sensu::transport_type != 'sensu' {
    $ensure = 'absent'
  } else {
    $ensure = 'present'
  }

  package { 'sensu-transport-snssqs':
    ensure         => 'installed',
    provider       => 'sensu_gem',
  }

  file { "${sensu::conf_dir}/snssqs.json":
    ensure => $ensure,
    owner  => $::sensu::user,
    group  => $::sensu::group,
    mode   => $::sensu::file_mode,
    before => Sensu_snssqs_config[$::fqdn],
  }

  $base_path         = $::sensu::conf_dir
  $region            = $::sensu::snssqs_region
  $max_messages      = $::sensu::snssqs_max_messages 
  $wait_time_seconds = $::sensu::wait_time_seconds
  $sqs_queue_url     = $::sensu::sqs_queue_url
  $sns_topic_arn     = $::sensu::sns_topic_arn

  sensu_snssqs_config { $::fqdn:
    ensure            => $ensure,
    base_path         => $base_path,
    region            => $region,
    max_messages      => $max_messages,
    wait_time_seconds => $wait_time_seconds,
    sqs_queue_url     => $sqs_queue_url
    sns_topic_arn     => $sns_topic_arn
  }
