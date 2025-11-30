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
* `report[:slow]` → array of slow queries exceeding `100ms` (configurable in `Analyzer::SLOW_THRESHOLD_MS`)

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
* **Adjust slow query threshold** by modifying `RailsQueryTracer::Analyzer::SLOW_THRESHOLD_MS`.
* Avoid running in production unless you specifically need performance diagnostics, as it collects all queries in memory.

---

## Development

Clone the repository and build the gem:

```bash
git clone <repo-url>
cd rails-query-tracer
bundle install
bundle exec rake build
```

Run tests:

```bash
bundle exec rspec
```

---

## Contributing

1. Fork it ([https://github.com/your-username/rails-query-tracer/fork](https://github.com/your-username/rails-query-tracer/fork))
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

---

## License

MIT License. See `LICENSE.txt` for details.
