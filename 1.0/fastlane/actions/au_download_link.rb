require 'bitly'

module Fastlane
  module Actions

    class AuDownloadLinkAction < Action
      def self.run(params)
        git_hash = `git rev-parse --short HEAD`
        
        bitly = Bitly.new(params[:username], params[:api_key])
        bitly_url = bitly.shorten(URI.join(params[:url], git_hash.strip!).to_s).bitly_url
        
        Helper.log.info "Download link generated #{bitly_url}"
        return bitly_url
      end

      def self.description
        "Generate short artifact download link"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :username,
                                       env_name: "BITLY_USERNAME",
                                       description: "bit.ly username",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :api_key,
                                       env_name: "BITLY_API_KEY",
                                       description: "bit.ly api key",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :url,
                                       env_name: "GS_ARTIFACTS_DOWNLOAD_URL",
                                       description: "base url",
                                       optional: true)
        ]
      end

      def self.authors
        ["piotrbernad"]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end