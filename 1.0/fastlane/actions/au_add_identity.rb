require 'shellwords'

module Fastlane
  module Actions

    class AuAddIdentityAction < Action
      def self.run(params)
        # download cert from google storage
        command = "gsutil cp #{params[:gs_certificate_path].shellescape} cert.p12"
        Fastlane::Actions.sh command, log: true

        # unlock keychain
        command = "security unlock-keychain -p #{params[:keychain_password].shellescape} ~/Library/Keychains/#{params[:keychain_name].shellescape}"
        Fastlane::Actions.sh command, log: false

        # import cert
        command = "security import cert.p12 -k ~/Library/Keychains/#{params[:keychain_name].shellescape}"
        command << " -P #{params[:certificate_password].shellescape}" if params[:certificate_password]
        command << " -T /usr/bin/codesign"
        command << " -T /usr/bin/security"
        Fastlane::Actions.sh command, log: false
      end

      def self.description
        "Download cert from Google Storage, unlock keychain and add identity from inputfile into a keychain"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :keychain_name,
                                       env_name: "KEYCHAIN_NAME",
                                       description: "Keychain name into which item",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :keychain_password,
                                       env_name: "KEYCHAIN_PASSWORD",
                                       description: "Keychain password into which item",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :certificate_password,
                                       env_name: "CERTIFICATE_PASSWORD",
                                       description: "Certificate password",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :gs_certificate_path,
                                       env_name: "GS_CERTIFICATE_PATH",
                                       description: "Google Storage cert file path",
                                       optional: false),
        ]
      end

      def self.authors
        ["emilwojtaszek"]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end