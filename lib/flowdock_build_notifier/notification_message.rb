module FlowdockBuildNotifier
  class NotificationMessage
    attr_reader :build
    def initialize(build)
      @build = build
    end

    def to_s
      "#{status}: \"#{build.name}\" build#{branch} - #{build.url}"
    end

    def branch
      " for branch #{build.branch}" if build.branch
    end

    def status
      {
        "SUCCESS" => "#{pass_status}",
        "FAILURE" => "❌ FAILED",
        "UNKNOWN" => "🚧 CANCELED",
      }[build.status]
    end

    def pass_status
      case build.name
      when /deploy/i
        "🚀 DEPLOYED"
      when /smoke/i
        "🚬 SMOKED"
      else
        "✅ PASSED"
      end
    end
  end
end
