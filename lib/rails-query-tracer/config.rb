# frozen_string_literal: true

module RailsQueryTracer
  module Config
    class << self
      attr_accessor :threshold_ms, :show_stack_trace, :log_to_file

      def setup_defaults
        @threshold_ms = 50
        @show_stack_trace = true
        @log_to_file = nil
      end
    end

    setup_defaults
  end
end
