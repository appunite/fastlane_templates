require 'shellwords'

module Fastlane
  module Actions

    class AuProvisionDownloadAction < Action
      def self.run(params)
        # download cert from google storage
        command = "gsutil cp #{params[:gs_prov_path].shellescape} distribution.mobileprovision"
        Fastlane::Actions.sh command, log: true
      end

      def self.description
        "Download provisioning provile from Google Storage"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :gs_prov_path,
                                       env_name: "GS_TF_PROV_PATH",
                                       description: "Google Storage provisioning file path",
                                       optional: true),
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