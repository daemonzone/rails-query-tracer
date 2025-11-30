# spec/tracker_spec.rb
require "spec_helper"
require "active_support"
require "active_support/core_ext"
require "active_support/notifications"
require "rails-query-tracer/tracker"

RSpec.describe RailsQueryTracer::Tracker do

  before(:each) do
    RailsQueryTracer::Tracker.reset!
    RailsQueryTracer::Tracker.start
  end

  after(:each) do
    RailsQueryTracer::Tracker.stop
    RailsQueryTracer::Tracker.reset!
  end

  describe ".start and .queries" do
    it "tracks SQL queries" do
      ActiveSupport::Notifications.instrument("sql.active_record", name: "User Load", sql: "SELECT * FROM users") do
        # simulate code block
      end

      queries = RailsQueryTracer::Tracker.queries
      expect(queries).not_to be_empty
      expect(queries.first[:sql]).to eq("SELECT * FROM users")
      expect(queries.first[:duration]).to be_a(Float)
      expect(queries.first[:location]).to be_a(String)
    end

    it "ignores schema queries" do
      ActiveSupport::Notifications.instrument("sql.active_record", name: "SCHEMA", sql: "SELECT * FROM schema_migrations") do
      end

      expect(RailsQueryTracer::Tracker.queries).to be_empty
    end
  end

  describe ".reset!" do
    it "clears all tracked queries" do
      ActiveSupport::Notifications.instrument("sql.active_record", name: "User Load", sql: "SELECT * FROM users") {}

      # instead of size, assert presence
      user_queries = RailsQueryTracer::Tracker.queries.select { |q| q[:sql] == "SELECT * FROM users" }
      expect(user_queries).not_to be_empty

      RailsQueryTracer::Tracker.reset!
      expect(RailsQueryTracer::Tracker.queries).to be_empty
    end
  end

  describe ".extract_location" do
    it "returns a non-gem, non-ruby caller line" do
      location = RailsQueryTracer::Tracker.send(:extract_location)
      expect(location).to be_a(String)
      expect(location).not_to include("/gems/")
      expect(location).not_to include("/ruby/")
    end
  end
end
