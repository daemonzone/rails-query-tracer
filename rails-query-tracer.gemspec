# frozen_string_literal: true

require_relative "lib/rails-query-tracer/version"

Gem::Specification.new do |spec|
  spec.name          = "rails-query-tracer"
  spec.version       = RailsQueryTracer::VERSION
  spec.authors       = ["Davide V."]
  spec.email         = ["daemonzone@users.noreply.github.com"]
  spec.summary       = "Trace and detect slow queries and N+1 problems in Rails"
  spec.description   = "RailsQueryTracer hooks into ActiveRecord, finds N+1 queries, slow queries, " \
                       "and provides actionable insights with optional dashboard."
  spec.files         = Dir["lib/**/*.rb"]
  spec.homepage      = "https://github.com/yourusername/rails-query-tracer"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.7.6"

  spec.add_dependency "rails", ">= 6.0"
  spec.metadata["rubygems_mfa_required"] = "true"
end
