# RailsQueryTracer

RailsQueryTracer hooks into ActiveRecord and helps you detect **N+1 queries** and **slow queries** in your Rails applications. It provides actionable insights and can optionally be integrated into a dashboard.

---

## Installation

Add this line to your application's Gemfile:

```ruby
gem "rails-query-tracer", "~> 0.1.0"
```

Then execute:

```bash
bundle install
```

Or install it manually:

```bash
gem install rails-query-tracer
```

---

## Usage

### Configuration

You can customize RailsQueryTracer's behavior by setting options in an initializer (`config/initializers/rails_query_tracer.rb`):

```ruby
RailsQueryTracer::Config.slow_queries_threshold = 50   # default is 20ms
RailsQueryTracer::Config.show_stack_trace = true       # default is true
RailsQueryTracer::Config.log_to_file = "log/query_tracer.log" # optional
```

### Tracking Queries

Start tracking SQL queries anywhere in your application (typically in a Rails initializer or a before hook):

```ruby
RailsQueryTracer::Tracker.reset!
RailsQueryTracer::Tracker.start
```

Stop tracking if needed:

```ruby
RailsQueryTracer::Tracker.stop
```

Access the collected queries:

```ruby
queries = RailsQueryTracer::Tracker.queries
```

### Analyzing Queries

Analyze tracked queries to detect N+1 or slow queries:

```ruby
report = RailsQueryTracer::Analyzer.analyze(queries)
```

* `report[:n_plus_one]` → array of detected N+1 queries
* `report[:slow]` → array of slow queries exceeding `RailsQueryTracer::Config.slow_queries_threshold` (default 20ms)

### Reporting

Print a human-readable report:

```ruby
RailsQueryTracer::Reporter.report(report)
```

Sample output:

```
[RailsQueryTracer] N+1 Queries:
  SELECT * FROM users repeated 5 times at app/models/post.rb:12

[RailsQueryTracer] Slow Queries:
  SELECT * FROM orders (250.32ms) at app/controllers/orders_controller.rb:45

[RailsQueryTracer] Report Complete
```

---

## Tips & Best Practices

* **Reset Tracker** before each request in development to avoid mixing queries from different actions.
* **Ignore schema queries** automatically—RailsQueryTracer ignores `SCHEMA` queries by default.
* **Combine with `bullet`** for automated notifications in development if you want live alerts.
* **Adjust slow query threshold** via `RailsQueryTracer::Config.slow_queries_threshold`.
* Avoid running in production unless you specifically need performance diagnostics, as it collects all queries in memory.

---

## Contributing

1. Fork it ([https://github.com/your-username/rails-query-tracer/fork](https://github.com/your-username/rails-query-tracer/fork))
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

---

## License

MIT License
