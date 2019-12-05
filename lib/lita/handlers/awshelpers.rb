# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'
require 'yaml'

module Lita
  module Handlers
    # Some helpers to setup and interact with various aws services.
    module AwsHelpers
      DEFAULT_USERDATA_URI = 'http://169.254.169.254/latest/user-data'.freeze

      def aws_region
        @aws_region ||= initialize_aws_region
      end

      def retrieve_from_userdata(key, userdata_type = :auto, source = DEFAULT_USERDATA_URI)
        userdata = user_data(source, userdata_type)
        userdata[key]
      end

      def user_data(source, type = :auto)
        @user_data ||= initialize_user_data(source, type)
      end

      def credentials_from_role(role, debug = false)
        @aws_session ||= initialize_aws_session_from_role(role, debug)
        @aws_session.credentials
      end

      def configure_aws_region(region = nil)
        if region
          ::Aws.config.update(region: region)
        else
          ::Aws.config.update(region: aws_region)
        end
      end

      private

      def initialize_aws_session_from_role(role, debug)
        require 'awssession'
        require 'aws_config'
        profile = AWSConfig[role]
        profile['name'] = role
        session = AwsSession.new(profile: profile, debug: debug)
        session.start
        session
      end

      def initialize_user_data(source, type)
        data = get_resource(source)
        case type
        when 'yaml', :yaml
          parse_yaml(data, true)
        when 'json', :json
          parse_json(data, true)
        else
          parse_auto(data)
        end
      end

      def parse_auto(data)
        parsed = parse_yaml(data)
        parsed = parse_json(data) if parsed.nil?
        raise ArgumentError, 'Could not determine the format of the user-data' if parsed.nil?

        parsed
      end

      def parse_json(json, raise = false)
        JSON.parse(json)
      rescue JSON::ParserError => e
        raise e if raise

        nil
      end

      def parse_yaml(yaml, raise = false)
        YAML.safe_load(yaml)
      rescue YAML::ParseError => e
        raise e if raise

        nil
      end

      def initialize_aws_region
        url = 'http://169.254.169.254/latest/dynamic/instance-identity/document'
        JSON.parse(get_resource(url))['region']
      end

      def get_resource(url)
        uri = URI.parse(url)
        return File.read(url) unless %w[http https].include?(uri.scheme)

        http = Net::HTTP.new(uri.host, uri.port)
        http.read_timeout = 2
        http.open_timeout = 2
        response = http.start { |h| h.get(uri.path) }
        response.body
      end
    end
  end
end
