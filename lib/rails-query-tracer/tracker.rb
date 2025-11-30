# frozen_string_literal: true

require "active_support/notifications"

module RailsQueryTracer
  class Tracker
    @queries = []

    class << self
      attr_reader :queries

      def start
        @notifications = ActiveSupport::Notifications
        @subscriber = @notifications.subscribe("sql.active_record") do |_name, start, finish, _id, payload|
          next if payload[:name] == "SCHEMA"

          location = extract_location
          @queries << {
            sql: payload[:sql],
            duration: (finish - start) * 1000,
            location: location
          }
        end
      end

      def stop
        ActiveSupport::Notifications.unsubscribe(@subscriber) if @subscriber
        @subscriber = nil
      end

      def extract_location
        caller.reject { |line| line.include?("/gems/") || line.include?("/ruby/") }.first
      end

      def reset!
        @queries = []
      end
    end
  end
end
