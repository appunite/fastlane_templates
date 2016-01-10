module Fastlane
  module Actions

    class AuBuildTrackerAction < Action
      def self.run(params)
        require 'httparty'
        require 'uri'
        
        uri = URI.parse("http://api-build-tracker-staging.appunite.com/builds")
       
        response = HTTParty.post(uri, { body: { 'build' =>
          {   'app_id' => params[:app_id],
              'name' => params[:build_name],
              'number' => params[:build_number],
              'artefact_url' => params[:download_url],
              'status' => params[:status] || 'integrated'
          }
        }})
        
        Helper.log.info "Posting new build info to Appunite Build Tracker with data: AppName: #{params[:app_id]} BuildName:  #{params[:build_name]} BuildNumber:  #{params[:build_number]} DownloadURL:  #{params[:download_url]}"
        
        check_response_code(response)
      end

      def self.description
        "Update Build Status on Appunite Build Tracker"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :build_number,
                                       env_name: "CI_BUILD_ID",
                                       description: "Build Number",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :status,
                                       env_name: "AU_TRACKER_STATUS",
                                       description: "AU Tracker Status",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :build_name,
                                       env_name: "CI_BUILD_REF",
                                       description: "Commit Hash",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :app_id,
                                       env_name: "GITLAB_PROJECT_ID",
                                       description: "Gitlab Project ID",
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :download_url,
                                       env_name: "AU_DOWNLOAD_URL",
                                       description: "Download url",
                                       optional: true),
        ]
      end

      def self.check_response_code(response)
        case response.code.to_i
          when 200, 204, 201, 400
            if response.code.to_i == 400
              Helper.log.info "Build with this number already exist in build tracker. Please make sure that you try to build correct commit"
            end
            
          else
            raise "Unexpected #{response.code} with response: #{response.body}".red
          end
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