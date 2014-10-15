require 'rexml/document'
require 'net/https'

require_relative 'configuration'

module FlowdockBuildNotifier
  class BuildMetadata
    attr_reader :metadata, :config

    def initialize(config: Configuration.load)
      @config = config
    end

    def fetch(build_id)
      build_uri = URI("#{config.teamcity_url}/httpAuth/app/rest/builds/#{build_id}")

      Net::HTTP.start(build_uri.host, build_uri.port, use_ssl: true) do |http|
        request = Net::HTTP::Get.new(build_uri)
        request.basic_auth config.teamcity_user, config.teamcity_password
        @result = http.request(request).body
      end
      @metadata = REXML::Document.new(@result)
    end

    def status
      metadata.root.attributes['status']
    end

    def url
      metadata.root.attributes['webUrl']
    end

    def branch
      metadata.root.attributes['branchName']
    end

    def name
      project_name = metadata.root.elements['buildType'].attributes['projectName']
      name = metadata.root.elements['buildType'].attributes['name']
      [project_name, name].compact.join(" :: ")
    end
  end
end
