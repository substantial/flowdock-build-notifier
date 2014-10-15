require 'yaml'

module FlowdockBuildNotifier
  class Configuration
    FLOWDOCK_CONFIG = '.flowdock_build_notifier.yml'

    def self.load
      new(YAML.load_file(FLOWDOCK_CONFIG))
    rescue Errno::ENOENT
      raise "#{FLOWDOCK_CONFIG} configuration not found"
    end

    attr_reader :flow_name, :flowdock_user_token, :teamcity_user,
      :teamcity_password, :teamcity_url, :email_map

    def initialize(config)
      @flowdock_user_token = config.fetch('flowdock_user_token')
      @flow_name= config.fetch('flow_name')
      @email_map = config.fetch('email_map') { {} }

      @teamcity_url = config.fetch('teamcity_url')
      @teamcity_user = config.fetch('teamcity_user')
      @teamcity_password = config.fetch('teamcity_password')
    end
  end
end
