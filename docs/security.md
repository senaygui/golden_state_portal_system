# Security & Access

- Authentication via Devise; ensure secure password policies in production.
- Authorization via CanCanCan (`Ability`); review rules in `app/models/ability.rb`.
- Admin access via ActiveAdmin at `/admin`.
- Do not commit secrets. Use environment variables and/or Rails credentials.
- Force SSL in production (via environment config) behind a TLS terminator.
- Keep wkhtmltopdf binaries up-to-date and from trusted sources.
- Background job queues should be on private networks; secure Redis with auth if exposed.
