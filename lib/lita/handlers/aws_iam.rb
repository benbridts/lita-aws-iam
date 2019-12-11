require 'json'
require 'aws-sdk-iam'

module Lita
  module Handlers
    # Class for handling IAM permission
    class AwsIam < Handler
      include Lita::Handlers::AwsHelpers

      help = { 'iam' => 'Manage IAM permissions' }
      route(/iam/, :handle_iam, command: true, help: help)

      def handle_iam(response)
        configure_aws_region
        list_users
        response.reply('iam permissions granted')
      end

      def list_users
        list_users_response = iam_client.list_users
        list_users_response.users.each do |user|
          puts user.user_name
        end
      end

      # Creates (if needed) and returns the ssm_client..
      def iam_client
        @iam_client ||= initialize_iam_client
      end

      def initialize_iam_client
        Aws::IAM::Client.new
      end

      Lita.register_handler(self)
    end
  end
end
