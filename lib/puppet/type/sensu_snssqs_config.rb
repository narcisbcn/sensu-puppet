require 'set'
require File.expand_path(File.join(File.dirname(__FILE__), '..', '..',
                                   'puppet_x', 'sensu', 'boolean_property.rb'))

Puppet::Type.newtype(:sensu_snssqs_config) do
  @doc = 'Manages AWS SNS and SQS config'

  def initialize(*args)
    super(*args)

    if c = catalog
      self[:notify] = [
        'Service[sensu-server]',
        'Service[sensu-client]',
        'Service[sensu-api]',
        'Service[sensu-enterprise]',
      ].select { |ref| c.resource(ref) }
    end
  end

  ensurable do
    newvalue(:present) do
      provider.create
    end

    newvalue(:absent) do
      provider.destroy
    end

    defaultto :present
  end

  newparam(:name) do
    desc 'This value has no effect, set it to what ever you want.'
  end

  newparam(:base_path) do
    desc 'The base path to the client config file'
    defaultto '/etc/sensu/conf.d/'
  end

  newproperty(:max_messages) do
    desc 'Max number of messages'
    defaultto { '10' }

    def insync?(is)
      return should == is if should.is_a?(Symbol)
      super(is)
    end
  end

  newproperty(:wait_time_seconds) do
    desc 'Wait time in seconds'
    defaultto { '2' }

    def insync?(is)
      return should == is if should.is_a?(Symbol)
      super(is)
    end
  end

  newproperty(:region) do
    desc 'Region where SQS and SNS are'
    defaultto { 'us-east-1' }

    def insync?(is)
      return should == is if should.is_a?(Symbol)
      super(is)
    end
  end

  newproperty(:consuming_sqs_queue_url) do
    desc 'HTTP SQS URL'
    defaultto { 'https://' }

    def insync?(is)
      return should == is if should.is_a?(Symbol)
      super(is)
    end
  end

  newproperty(:publishing_sns_topic_arn) do
    desc 'ARN SNS URL'
    defaultto { 'arn:aws:sns:' }

    def insync?(is)
      return should == is if should.is_a?(Symbol)
      super(is)
    end
  end

  autorequire(:package) do
    ['sensu']
  end
end
