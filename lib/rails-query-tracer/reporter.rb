# frozen_string_literal: true

module RailsQueryTracer
  class Reporter
    RED    = "\e[31m"
    GREEN  = "\e[32m"
    YELLOW = "\e[33m"
    CYAN   = "\e[36m"
    RESET  = "\e[0m"

    def self.report(report)
      n_plus_one_queries = report[:n_plus_one] || []
      slow = report[:slow] || []

      report_n_plus_one(n_plus_one_queries)
      report_slow_queries(slow)
      report_success if n_plus_one_queries.empty? && slow.empty?
      report_complete
    end

    def self.report_n_plus_one(n_plus_one_queries)
      return unless n_plus_one_queries.any?

      puts "#{YELLOW}[RailsQueryTracer] N+1 Queries:#{RESET}"
      n_plus_one_queries.each do |q|
        locs = Array(q[:locations])
        puts "  #{q[:sql]} repeated #{q[:count]} times at #{locs.join(', ')}"
      end
    end

    def self.report_slow_queries(slow)
      return unless slow.any?

      puts "#{RED}[RailsQueryTracer] Slow Queries:#{RESET}"
      slow.each do |q|
        sql      = q[:sql] || "unknown SQL"
        duration = q[:duration] ? "#{q[:duration].round(2)}ms" : "unknown duration"
        loc      = q[:location] || "unknown"
        puts "  #{sql} (#{duration}) at #{loc}"
      end
    end

    def self.report_success
      puts "#{GREEN}[RailsQueryTracer] No N+1 or slow queries detected#{RESET}"
    end

    def self.report_complete
      puts "#{CYAN}[RailsQueryTracer] Report Complete#{RESET}"
    end
  end
end
