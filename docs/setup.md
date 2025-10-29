# Setup Guide

This app is a Ruby on Rails monolith.

- Ruby: 3.1.2 (see `.ruby-version`)
- Bundler: 2.4.x (see `Gemfile.lock`)
- Rails: 7.0.8.4
- Node/Yarn: only needed for asset tooling if you add Node-based tools; current app uses Sprockets and does not require Node.
- Database: PostgreSQL 12+
- Redis: required for Sidekiq (background jobs)
- wkhtmltopdf: required for HTML-to-PDF via `wicked_pdf`

## 1) Clone and bootstrap

```bash
bundle install
bin/rails db:setup   # creates, loads schema, seeds if any
```

If you get pg compile issues, ensure PostgreSQL client headers are installed and `pg_config` is on PATH.

## 2) Environment variables

Create `.env` (dotenv-rails) and set:

- `DB_USERNAME`, `DB_PASSWORD`, `DB_HOST`, `DB_PORT` — see `config/database.yml`
- `PORTAL_SYSTEM_DATABASE_PASSWORD` — production `database.yml`
- Any additional secrets used by integrations (e.g., Moodle if configured)

See `docs/configuration.md` for details.

## 3) Run the app

```bash
# Start Rails server
bin/rails s

# In another terminal, start Sidekiq (if jobs are used)
bundle exec sidekiq
```

Visit http://localhost:3000

- Public root: `pages#home`
- Admin: `/admin` (ActiveAdmin)

## 4) wkhtmltopdf

Install wkhtmltopdf 0.12.6+ compatible with your OS to support `wicked_pdf`.

## 5) Seeds and access

Check `db/seeds.rb` (if present) for initial users. For ActiveAdmin, create an admin user via console if none exists:

```ruby
AdminUser.create!(email: "admin@example.com", password: "password", password_confirmation: "password")
```

## 6) Tests

```bash
bundle exec rspec
```
See `docs/testing.md`.
