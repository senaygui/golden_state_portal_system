# Operations

## Processes

- Web: Puma (via `rails s` or your process manager)
- Background: Sidekiq (`bundle exec sidekiq`)

## Health

- App boots with root at `pages#home`
- Admin at `/admin`

## Jobs

- Sidekiq required if any async jobs are enqueued (check `app/jobs/`)
- Configure Redis via `REDIS_URL`

## PDFs

- `wicked_pdf` uses wkhtmltopdf for HTML-to-PDF
- `prawn` used for programmatic PDFs (e.g., grade reports)

## Common Rake tasks

```bash
bin/rails db:migrate
bin/rails db:seed
bin/rails assets:precompile RAILS_ENV=production
```

## Deployment

- Capistrano included (see gems: `capistrano`, `capistrano-rails`, `capistrano-passenger`, `capistrano-rbenv`, `capistrano-rails-db`)
- Ensure:
  - System Ruby or rbenv with Ruby 3.1.2
  - PostgreSQL, Redis available
  - wkhtmltopdf installed

## Logs

- Rails logs under `log/`
- Sidekiq logs depend on your process manager; by default to STDOUT

## Background schedules

- `whenever` gem present for cron-based schedules. Check `config/schedule.rb` (if present) for jobs.
