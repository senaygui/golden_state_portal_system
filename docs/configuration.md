# Configuration

## Environment variables

- Database (see `config/database.yml`)
  - `DB_USERNAME`
  - `DB_PASSWORD`
  - `DB_HOST`
  - `DB_PORT`
  - Production: `PORTAL_SYSTEM_DATABASE_PASSWORD` if using user `portal_system`
- Rails
  - `RAILS_MAX_THREADS` (optional)
  - `RAILS_ENV` (`development`/`test`/`production`)
- Redis
  - `REDIS_URL` (if not default, for Sidekiq)
- PDF
  - `WKHTMLTOPDF_BINARY` (optional if not on PATH)
- Integrations
  - Moodle: environment variables as required by `moodle_rb` (e.g., endpoint URL, token). Consult integration code if used.

Store local values in `.env` (dotenv-rails), never commit secrets.

## Rails configuration

- `config/application.rb`
  - `config.load_defaults 5.2` with Rails 7 gems — legacy defaults retained
  - Asset pipeline via Sprockets; precompiles ActiveAdmin and font assets

## Credentials and secrets

Consider using `rails credentials:edit` for production secrets or environment-based secret management.
