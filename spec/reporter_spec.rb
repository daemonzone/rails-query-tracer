# spec/reporter_spec.rb
require "spec_helper"
require "stringio"
require "rails-query-tracer/reporter"

RSpec.describe RailsQueryTracer::Reporter do
  let(:n_plus_one_queries) do
    [
      { sql: "SELECT * FROM books WHERE author_id = ?", count: 3, locations: ["file1.rb:10", "file2.rb:12"] }
    ]
  end

  let(:slow_queries) do
    [
      { sql: "SELECT * FROM authors", duration: 150, location: "file3.rb:20" }
    ]
  end

  before do
    @original_stdout = $stdout
    $stdout = StringIO.new
  end

  after do
    $stdout = @original_stdout
  end

  def output
    $stdout.string
  end

  describe ".report" do
    context "when there are N+1 queries" do
      it "prints N+1 queries" do
        described_class.report(n_plus_one: n_plus_one_queries, slow: [])
        expect(output).to include("[RailsQueryTracer] N+1 Queries:")
        expect(output).to include("SELECT * FROM books WHERE author_id = ? repeated 3 times at file1.rb:10, file2.rb:12")
      end
    end

    context "when there are slow queries" do
      it "prints slow queries" do
        described_class.report(n_plus_one: [], slow: slow_queries)
        expect(output).to include("[RailsQueryTracer] Slow Queries:")
        expect(output).to include("SELECT * FROM authors (150ms) at file3.rb:20")
      end
    end

    context "when there are no queries" do
      it "prints success message" do
        described_class.report(n_plus_one: [], slow: [])
        expect(output).to include("[RailsQueryTracer] No N+1 or slow queries detected")
      end
    end

    context "always prints report complete" do
      it "prints the complete message" do
        described_class.report(n_plus_one: n_plus_one_queries, slow: slow_queries)
        expect(output).to include("[RailsQueryTracer] Report Complete")
      end
    end
  end
end
