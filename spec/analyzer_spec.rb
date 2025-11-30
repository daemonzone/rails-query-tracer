# spec/analyzer_spec.rb
require "spec_helper"
require "rails-query-tracer/analyzer"

RSpec.describe RailsQueryTracer::Analyzer do
  describe ".analyze" do
    let(:queries) do
      [
        # N+1 candidates
        { sql: "SELECT * FROM books WHERE author_id = ?", duration: 10, location: "file1.rb:10" },
        { sql: "SELECT * FROM books WHERE author_id = ?", duration: 12, location: "file2.rb:12" },
        # Slow query
        { sql: "SELECT * FROM authors", duration: 150, location: "file3.rb:20" },
        # Normal query
        { sql: "SELECT * FROM publishers", duration: 50, location: "file4.rb:30" }
      ]
    end

    it "detects N+1 queries" do
      report = described_class.analyze(queries)
      expect(report[:n_plus_one].size).to eq(1)
      n1 = report[:n_plus_one].first
      expect(n1[:sql]).to eq("SELECT * FROM books WHERE author_id = ?")
      expect(n1[:count]).to eq(2)
      expect(n1[:locations]).to match_array(["file1.rb:10", "file2.rb:12"])
    end

    it "detects slow queries" do
      report = described_class.analyze(queries)
      expect(report[:slow].size).to eq(1)
      slow = report[:slow].first
      expect(slow[:sql]).to eq("SELECT * FROM authors")
      expect(slow[:duration]).to eq(150)
      expect(slow[:location]).to eq("file3.rb:20")
    end

    it "returns empty arrays if no N+1 or slow queries" do
      empty_queries = [
        { sql: "SELECT * FROM authors", duration: 10, location: "file1.rb:5" }
      ]
      report = described_class.analyze(empty_queries)
      expect(report[:n_plus_one]).to eq([])
      expect(report[:slow]).to eq([])
    end
  end

  describe ".detect_n_plus_one" do
    it "filters out single queries" do
      queries = [{ sql: "SELECT * FROM books", duration: 10, location: "file.rb:1" }]
      result = described_class.detect_n_plus_one(queries)
      expect(result).to eq([])
    end
  end

  describe ".detect_slow_queries" do
    it "filters out fast queries" do
      queries = [{ sql: "SELECT * FROM authors", duration: 50, location: "file.rb:2" }]
      result = described_class.detect_slow_queries(queries)
      expect(result).to eq([])
    end
  end
end
