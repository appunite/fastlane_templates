module Fastlane
  module Actions
  
    class AuArtifactsUploadAction < Action
      def self.run(params)
        # generate artifacts path
        git_hash = `git rev-parse --short HEAD`
        artifacts_path = File.join(ENV["GS_ARTIFACTS_BUCKET"], git_hash).to_s.shellescape

        # filenames      
        ipa = File.basename(ENV["IPA_OUTPUT_PATH"])
        dsym = File.basename(ENV["DSYM_OUTPUT_PATH"])

        # zip file ipa & dsym
        command = "tar -zcvf data.tgz #{ipa} #{dsym}"
        Fastlane::Actions.sh command, log: false

        # upload zip
        command = "gsutil cp data.tgz #{artifacts_path}"
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