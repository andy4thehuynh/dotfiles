---
paths:
  - "**/*_spec.rb"
  - "**/spec/**"
  - "**/test_*.py"
  - "**/*_test.py"
  - "**/tests/**"
  - "**/*_test.go"
  - "**/*.{test,spec}.{js,ts,jsx,tsx}"
---

# Testing Conventions

## Core Rules

- **Never delete failing tests** to make the suite pass. Fix the test or fix the code.
- **Unit tests SHOULD hit the database.** Real database operations over mocks — do not stub your own models, services, ActiveRecord associations, or plain objects.
- **Mock only true externals**: third-party APIs (Stripe, Twilio), payment processors, email delivery, and time-dependent operations. Nothing else.
- **System/feature tests cover the happy path, plus any error path whose behavior only exists at the integration boundary.** A validation failure that must re-render through a Turbo Stream has no unit-level equivalent — the unit test passes and the user still sees a broken page. Everything else stays out: no branching logic, no exhaustive edge cases in browser tests. Edge cases belong in unit tests, where they run fast and localize the failure.
- **Keep tests simple**: no conditionals or loops inside test bodies.
- Write tests alongside every feature and bug fix, not after.

## Mocking Boundaries

DO mock:
- External APIs, payment processors, email services
- Time (`travel_to` / freezing)

DON'T mock:
- Database operations
- Your own models and services
- ActiveRecord associations
- Simple Ruby/Python/JS objects

```ruby
# Bad - stubbing your own service
allow(OrderService).to receive(:create_order).and_return(order)

# Good - stub only the external boundary
allow(Stripe::Charge).to receive(:create).and_return(
  double(id: 'ch_123', status: 'succeeded')
)
```

## Rails / RSpec

- **Prefer request specs over controller specs.**
- **Prefer FactoryBot over fixtures.** Use traits for variants and transient attributes for counts:

```ruby
factory :user do
  email { Faker::Internet.unique.email }
  role { 'member' }

  trait :admin do
    role { 'admin' }
  end

  trait :with_articles do
    transient do
      articles_count { 3 }
    end

    after(:create) do |user, evaluator|
      create_list(:article, evaluator.articles_count, user: user)
    end
  end
end
```

- Use `build_stubbed(:user)` when persistence isn't needed; `create` only when the test hits the database. Limit factory association chains for speed.
- Use `let_it_be` for expensive shared setup created once per describe block.
- Use shoulda-matchers one-liners for validations and associations (`it { should validate_presence_of(:email) }`).
- System specs: one spec can walk create/edit/delete in a single happy-path flow rather than three separate specs.
- Assert enqueued jobs for email, not delivery:

```ruby
expect {
  UserService.create_user(email: 'test@example.com')
}.to have_enqueued_job(ActionMailer::MailDeliveryJob)
```

## JavaScript / Hotwire

- **Test Stimulus controllers through Rails system tests**, not JS unit test frameworks — assert the Turbo Stream / DOM outcome.
- Jest or Vitest for actual JS logic (utilities, React components); match whatever the project already uses.

## Flaky-Test Hygiene

- Never assert on implicit record ordering — use explicit `order(...)` or `match_array`.
- Never compare timestamps for equality:

```ruby
# Bad
expect(article.created_at).to eq(Time.current)

# Good
expect(article.created_at).to be_within(1.second).of(Time.current)
```

## Coverage

- Aim for ~80% on critical paths; 100% is explicitly not the goal.
- Prioritize business logic; skip trivial code.

## Formatting

- 2-space indentation in test code, matching the rest of the codebase. Exceptions: Python tests use standard 4-space (PEP 8), Go tests use `gofmt` tabs.
