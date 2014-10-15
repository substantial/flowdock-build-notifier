require_relative 'configuration'

require 'flowdock'

module FlowdockBuildNotifier
  class FlowdockMessageSender
    attr_reader :config, :client

    def initialize(options = {})
      @options = options
      @config = @options.fetch(:config) { Configuration.load }
      @client = @options.fetch(:client) { Flowdock::Client.new(api_token: config.flowdock_user_token) }
    end

    def send_message(message)
      raise NotImplementedError
    end

    def messages_path
      raise NotImplementedError
    end
  end

  class PrivateMessageSender < FlowdockMessageSender
    def user_id
      @options.fetch :user_id
    end

    def send_message(message)
      client.post("/private/#{user_id}/messages", event: 'message', content: message.to_s)
    end
  end

  class TeamRoomSender < FlowdockMessageSender
    def flow
      @flow_id ||= client.get('/flows').detect do |flow|
        flow['name'] == config.flow_name
      end
    end

    def send_message(message)
      client.chat_message(flow: flow['id'], content: message.to_s)
    end
  end

  class UnknownUserSender < TeamRoomSender
    def email
      @options.fetch :email
    end

    def send_message(message)
      super
      super "Please add #{email} to .flowdock_build_notifier.yml"
    end
  end
end
