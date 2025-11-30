# frozen_string_literal: true

module RailsQueryTracer
  class Analyzer
    def self.analyze(queries)
      { n_plus_one: detect_n_plus_one(queries), slow: detect_slow_queries(queries) }
    end

    def self.detect_n_plus_one(queries)
      n1 = []
      queries.group_by { |q| q[:sql] }.each do |sql, repeated|
        next unless repeated.size > 1

        locs = repeated.filter_map { |q| q[:location] }.uniq
        n1 << { sql: sql, count: repeated.size, locations: locs }
      end
      n1
    end

    def self.detect_slow_queries(queries)
      queries.select { |q| q[:duration] && q[:duration] > RailsQueryTracer::Config.slow_queries_threshold }.map do |q|
        { sql: q[:sql], duration: q[:duration], location: q[:location] }
      end
    end
  end
end
