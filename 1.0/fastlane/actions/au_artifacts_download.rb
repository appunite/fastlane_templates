module Fastlane
  module Actions
    
    class AuArtifactsDownloadAction < Action
      def self.run(params)
        # generate artifacts path
        git_hash = `git rev-parse --short HEAD`
        artifacts_path = File.join(ENV["GS_ARTIFACTS_BUCKET"], git_hash, "data.tgz").to_s.shellescape

        # download zip
        command = "gsutil cp #{artifacts_path} data.tgz"
        Fastlane::Actions.sh command, log: false

        # unzip file
        command = "tar -jxvf data.tgz"
        Fastlane::Actions.sh command, log: false

        # clean up
        command = "rm data.tgz"
        Fastlane::Actions.sh command, log: false
      end

      def self.description
        "Transfer ipa/dSYM file to Google Storage"
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