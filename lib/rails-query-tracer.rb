# frozen_string_literal: true

require "rails-query-tracer/version"
require "rails-query-tracer/config"
require "rails-query-tracer/tracker"
require "rails-query-tracer/analyzer"
require "rails-query-tracer/reporter"

module RailsQueryTracer
  class Error < StandardError; end

  def self.configure
    yield(Config)
  end
end
