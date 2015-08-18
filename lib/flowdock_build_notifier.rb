require 'flowdock'

require_relative 'flowdock_build_notifier/configuration'
require_relative 'flowdock_build_notifier/notification_message'
require_relative 'flowdock_build_notifier/flowdock_message_sender'
require_relative 'flowdock_build_notifier/build_metadata'
require_relative 'flowdock_build_notifier/flowdock_message_sender_factory'

module FlowdockBuildNotifier
  class FlowdockNotification
    attr_reader :build_id, :config

    def initialize(build_id)
      @build_id = build_id
      @config = Configuration.load
    end

    def notify
      sender = FlowdockMessageSenderFactory
        .new(config: config)
        .create_sender(notify_email)

      sender.send_message(message)
      notify_all if ENV['FLOWDOCK_NOTIFY_ALL_ON_FAILURE'] && build.status == "FAILURE"
    end

    def notify_all
      TeamRoomSender
        .new(config: config)
        .send_message("#{message} @all")
    end

    def message
      NotificationMessage.new(build)
    end

    def build
      @build ||= BuildMetadata.new(config: config).tap { |metadata| metadata.fetch(build_id) }
    end

    def author_email
      `git show --format=format:%ae`.split("\n").first
    end

    def notify_email
      return File.read('.flowdock_notify_email').strip if File.exists? '.flowdock_notify_email'
      author_email
    end
  end
end
