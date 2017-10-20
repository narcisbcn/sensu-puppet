require 'json' if Puppet.features.json?
require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..',
                                   'puppet_x', 'sensu', 'provider_create.rb'))

Puppet::Type.type(:sensu_snssqs_config).provide(:json) do
  confine :feature => :json
  include PuppetX::Sensu::ProviderCreate

  def conf
    begin
      @conf ||= JSON.parse(File.read(config_file))
    rescue
      @conf ||= {}
    end
  end

  def flush
    File.open(config_file, 'w') do |f|
      f.puts JSON.pretty_generate(conf)
    end
  end

  def pre_create
    conf['snssqs'] = {}
  end

  def destroy
    conf.delete 'snssqs'
  end

  def exists?
    conf.has_key? 'snssqs'
  end

  def config_file
    File.join(resource[:base_path],'snssqs.json').gsub(File::SEPARATOR, File::ALT_SEPARATOR || File::SEPARATOR)
  end

  def region
    conf['snssqs']['region'] || :absent
  end

  def region=(value)
    conf['snssqs']['region'] = value unless value == :absent
  end

  def max_messages
    conf['snssqs']['max_messages'] ? conf['snssqs']['max_messages'].to_s : :absent
  end

  def max_messages=(value)
    conf['snssqs']['max_messages'] = value.to_i unless value == :absent
  end

  def wait_time_seconds
    conf['snssqs']['wait_time_seconds'] ? conf['snssqs']['wait_time_seconds'].to_s : :absent
  end

  def wait_time_seconds=(value)
    conf['snssqs']['wait_time_seconds'] = value.to_i unless value == :absent
  end

  def sqs_queue_url
    conf['snssqs']['sqs_queue_url'] || :absent
  end

  def sqs_queue_url=(value)
    conf['snssqs']['sqs_queue_url'] = value unless value == :absent
  end

  def sns_topic_arn
    conf['snssqs']['sns_topic_arn'] || :absent
  end

  def sns_topic_arn=(value)
    conf['snssqs']['sns_topic_arn'] = value unless value == :absent
  end

end
