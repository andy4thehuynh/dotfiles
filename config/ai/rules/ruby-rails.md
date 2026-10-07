---
paths:
  - "**/*.rb"
  - "**/*.erb"
  - "**/*.rake"
  - "**/Gemfile"
---

# Ruby on Rails Preferences

## Architecture: where logic lives

- Multi-step operations (create + side effects, anything touching multiple models) go in a **service object**, not the model or controller. Convention: plain class in `app/services/`, class-method entry point delegating to an instance, transaction inside, and return the record (with errors attached) rather than raising to the controller:

  ```ruby
  class OrderService
    def self.create_order(params) = new.create_order(params)

    def create_order(params)
      order = Order.new(params)
      ActiveRecord::Base.transaction do
        order.save!
        update_inventory(order)
      end
      order
    rescue ActiveRecord::RecordInvalid => e
      order.errors.add(:base, e.message)
      order
    end
  end
  ```

- Beyond services: **form objects** for complex forms, **query objects** for complex queries, **decorators/presenters** for view logic. Concerns are allowed for genuinely shared behavior but use them sparingly — they are not a dumping ground.
- Callbacks: acceptable for one or two things intrinsic to the model's lifecycle. If a model accrues several `after_create` callbacks (email, profile, notify, defaults), that's the signal to move the flow into a service.
- Prefer Hotwire/Turbo/Stimulus for interactivity. Do not reach for React or another JS framework unless the project already uses one.

## Models

- Order the class body: `extend`/`include`, constants, associations, validations, scopes, callbacks, class methods, public instance methods, `private`.
- Encode reusable conditions as scopes, not inline `where` strings at call sites:

  ```ruby
  # Avoid
  User.where("created_at > ? AND status = ?", 1.week.ago, "active")

  # Prefer
  scope :active, -> { where(status: "active") }
  scope :recent, -> { where("created_at > ?", 1.week.ago) }
  User.active.recent
  ```

- Keep methods under ~10 lines; extract private methods rather than growing one method.

## Controllers & routing

- Stick to the 7 RESTful actions. For state changes, add `member do post :publish end` (or a small dedicated controller) rather than inventing non-REST actions.
- Nest resources at most one level deep, and restrict nested resources with `only:` (e.g. comments under articles with `only: [:create, :destroy]`).
- Namespace admin controllers under `namespace :admin`; version APIs as `api/v1` namespaces.

## Migrations

- Status-like columns: `t.string :status, default: "pending", null: false` with scopes per status, plus an index on the column.
- New columns get explicit `null:`/`default:`; decimals get explicit `precision`/`scale`. Foreign keys use `t.references ..., null: false, foreign_key: true`.
- Index anything you filter or sort by at write time — don't wait for slow queries (`status`, `created_at`, composite indexes for combined lookups).
- Data backfills go in their own migration, separate from schema changes, with `def down; raise ActiveRecord::IrreversibleMigration; end` unless truly reversible.

## Testing (RSpec)

- FactoryBot for test data — never fixtures. Faker for values.
- Tests hit the real database. Do not stub ActiveRecord or mock internal collaborators; mock only external services (APIs, payments, email delivery).
- Controller/request specs assert response codes and redirects, not internals.
- Feature specs cover a single happy path per flow, plus error paths that only exist at the integration boundary (a validation failure re-rendering through a Turbo Stream). No exhaustive edge cases at that level.

## New apps: generate lean

Default to a minimal `rails new` and add back only what the app actually needs. A stock generate drags in fixtures, system-test scaffolding, JBuilder, and Action Mailbox/Text that most apps never touch.

```bash
rails new myapp \
  --database=postgresql \
  --skip-test \
  --skip-system-test \
  --skip-jbuilder \
  --skip-action-mailbox \
  --skip-action-text
```

- Keep Solid Queue, Solid Cache, Solid Cable, Propshaft, and Kamal — those are the framework, not fat
- `--skip-test` only because RSpec replaces Minitest; never ship an app with no test layer
- Drop `--skip-action-mailbox`/`--skip-action-text` from the command if the app genuinely handles inbound mail or rich text
- Add `--skip-docker` only when you know the app will not be containerized
- Prune the generated Gemfile of anything unused before the first commit

## Preferred gems

Check the Gemfile first. On Rails 8, lean on the framework before adding anything.

### Rails 8 ships these — do not add a gem

- **Background jobs**: Solid Queue is the default ActiveJob backend. Runs on the existing database via `FOR UPDATE SKIP LOCKED` — no Redis, and enqueue is transactional
- **Cache**: Solid Cache, not Redis or Memcached
- **WebSockets**: Solid Cable, not Redis
- **Assets**: Propshaft, not Sprockets
- **Deploy**: Kamal 2
- **Security scan**: `brakeman`, already in the generated Gemfile
- **Lint**: `rubocop-rails-omakase`, already configured — don't swap in a hand-rolled `.rubocop.yml`
- **Debugger**: the `debug` gem, already there — `pry-rails` is redundant on a new app
- **Auth scaffold**: `bin/rails generate authentication` — gives sign-in plus password reset, and tracks session history rather than only the latest session

### Reach for a gem when the default genuinely falls short

- **Auth**: start with the generator. `devise` earns its place when you need OmniAuth, confirmable, lockable, or multiple strategies — the generator is a foundation, not a Devise replacement
- **Authorization**: `pundit`. Rails ships no equivalent
- **Background jobs**: `sidekiq` when you already operate Redis, need sub-100ms pickup latency, or sustain well past ~5K jobs/min. Solid Queue's pickup runs ~100ms–1.2s against Sidekiq's ~8ms
- **Database**: `pg`. SQLite is production-viable on Rails 8 since the Solid trifecta runs on it — fine for single-server apps, but default to Postgres for anything that will scale out
- **Test**: `rspec-rails`, `factory_bot_rails`, `faker`, `capybara` — a deliberate swap for the bundled Minitest, per the testing skill

Vet anything else for active maintenance before proposing it.

## Style notes

- Run `rubocop -a` before handing work back, **scoped to the files you changed** — `bundle exec rubocop -a app/models/order.rb`. Bare `rubocop -a` autocorrects the whole repo and drags unrelated files into your diff.
- Predicate methods end in `?`; mutating/dangerous methods end in `!` (`publish!` uses `update!`).
- No `raw` in views without an explicit reason; prefer `sanitize` when HTML rendering is required.
