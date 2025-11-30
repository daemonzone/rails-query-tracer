# frozen_string_literal: true

module RailsQueryTracer
  module Config
    class << self
      attr_accessor :slow_queries_threshold, :show_stack_trace, :log_to_file

      def setup_defaults
        @slow_queries_threshold = 20
        @show_stack_trace = true
        @log_to_file = nil
      end
    end

    setup_defaults
  end
end
