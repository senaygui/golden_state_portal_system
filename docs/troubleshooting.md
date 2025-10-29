# Troubleshooting

## PostgreSQL (pg) compile errors
- Ensure `pg_config` is on PATH
- On macOS with Homebrew: `brew install postgresql` and re-run `bundle install`

## wkhtmltopdf not found
- Install wkhtmltopdf and/or set `WKHTMLTOPDF_BINARY`

## Redis/Sidekiq connection errors
- Set `REDIS_URL` or start local Redis (`brew services start redis`)

## Asset compilation issues
- Precompile: `bin/rails assets:precompile`
- Ensure Sprockets and gems (sass-rails, uglifier) are installed

## PDF generation layout issues
- Check CSS specificity and print CSS; wkhtmltopdf uses WebKit rendering
