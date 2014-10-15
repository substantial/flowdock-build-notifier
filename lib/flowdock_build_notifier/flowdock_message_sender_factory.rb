require_relative 'flowdock_message_sender'
require_relative 'configuration'

require 'flowdock'

module FlowdockBuildNotifier
  class FlowdockMessageSenderFactory
    attr_reader :config, :client

    def initialize(config: Configuration.load, client: Flowdock::Client.new(api_token: config.flowdock_user_token))
      @config = config
      @client = client
    end

    def create_sender(email)
      user = user_by_email(email)
      return UnknownUserSender.new(email: email, config: config) unless user
      PrivateMessageSender.new(user_id: user['id'], client: client)
    end

    def users
      @users ||= client.get('/users')
    end

    def user_by_email(email)
      @user ||= users.detect do |user|
        user['email'] == config.email_map[email] || user['email'] == email
      end
    end
  end
end
