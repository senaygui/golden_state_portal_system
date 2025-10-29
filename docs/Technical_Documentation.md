# Technical Documentation

## 1. Introduction

- **Purpose**
  - Provide a complete, practical reference for developing, deploying, operating, and maintaining the LMS Rails application (`PortalSystem`).
- **Scope**
  - Includes architecture, setup, configuration, deployment, usage, administration, security, testing, troubleshooting, and references.
  - Excludes detailed UI/UX design specifications and organization-specific policies not in the repo.
- **Audience**
  - Developers, DevOps/SRE, System Administrators, QA Engineers, and Stakeholders.
- **Definitions & Acronyms**
  - LMS: Learning Management System
  - ERD: Entity Relationship Diagram
  - DFD: Data Flow Diagram
  - RDBMS: Relational Database Management System (PostgreSQL)
  - PDF: Portable Document Format (WickedPDF/wkhtmltopdf, Prawn)

## 2. System Overview

- **High-level description**
  - Monolithic Ruby on Rails app powering an LMS with student self-service, registration, assessments, grading, documents, and administration.
- **Core features & modules**
  - Authentication (Devise), Authorization (CanCanCan), Student profiles
  - Semester registration, add/drop, transfers, readmissions, exemptions
  - Courses, sections, assessments, grade reports (HTML/PDF)
  - Invoices, payments, payment reports
  - Document requests and tracking; receipt upload
  - Academic calendar, class/exam schedules, notices
  - Admin console (ActiveAdmin) for data management and reporting
- **Architecture overview**
  - Rails MVC with service objects and PDF builders.
  - Background jobs with Sidekiq/Redis.
  - Storage: PostgreSQL; ActiveStorage enabled with validations.
- **Technology stack**
  - Ruby 3.1.2, Rails 7.0.8.4 (defaults 5.2), PostgreSQL, Puma, Sidekiq/Redis
  - Frontend: Sprockets, Turbolinks, jQuery, Bootstrap 4.6
  - Admin: ActiveAdmin (+ addons/themes)
  - PDFs: wicked_pdf + wkhtmltopdf, Prawn
  - Selected gems: Devise, CanCanCan, jsonb_accessor, simple_form, chartkick, dotenv-rails

See also: `docs/overview.md`.

## 3. Installation & Setup

- **System requirements**
  - OS: macOS/Linux (x86_64/arm64)
  - Ruby: 3.1.2 (see `.ruby-version`), Bundler 2.4.x
  - DB: PostgreSQL 12+
  - Redis (for Sidekiq)
  - wkhtmltopdf 0.12.6+ (HTML-to-PDF)
- **Prerequisites**
  - Build tools and PostgreSQL client headers (`pg_config` on PATH)
  - rbenv/rvm recommended to manage Ruby versions
- **Install**
  ```bash
  gem install bundler:2.4.13
  bundle install
  bin/rails db:setup    # creates DB, loads schema, seeds if any
  ```
- **Configuration**
  - Create `.env` and set:
    - DB: `DB_USERNAME`, `DB_PASSWORD`, `DB_HOST`, `DB_PORT`
    - Production DB: `PORTAL_SYSTEM_DATABASE_PASSWORD`
    - Redis: `REDIS_URL` (optional)
    - PDF: `WKHTMLTOPDF_BINARY` (optional)
    - Integrations (e.g., Moodle) as required
  - See `config/database.yml` and `docs/configuration.md`.
- **Run locally**
  ```bash
  bin/rails s         # http://localhost:3000
  bundle exec sidekiq # background jobs
  ```
- **Deployment**
  - Capistrano-enabled. Ensure server has Ruby 3.1.2, PostgreSQL, Redis, wkhtmltopdf.
  - Common tasks:
    ```bash
    bin/rails db:migrate
    bin/rails assets:precompile RAILS_ENV=production
    ```

See also: `docs/setup.md`, `docs/operations.md`.

## 4. Usage Guide

- **Access/Start**
  - Default root: `pages#home` (`/`)
  - Admin console: `/admin`
- **Main feature walkthroughs**
  - Registration: `GET /new/semester/registration` → submit → invoice/payment → status
  - Assessments: manage plans, enter results, approve grades, export PDF reports
  - Documents: request forms, track, pay, upload receipt, download PDFs
- **Command line/API usage**
  - Rake: `rake docs:build_pdf` to bundle docs into PDF (see `lib/tasks/docs.rake`)
- **User roles & permissions**
  - Devise models: Student, AdminUser
  - Authorization via CanCanCan; rules in `app/models/ability.rb`

See also: `docs/routes.md` for endpoints summary.

## 5. Architecture & Design Details

- **System architecture**
  - Controllers (`app/controllers/`), Models (`app/models/`), Views (`app/views/`)
  - Services (`app/services/`), Admin (`app/admin/`), PDFs (`app/pdfs/`)
- **Database**
  - PostgreSQL with extensive domain models:
    - e.g., `Student`, `SemesterRegistration`, `Course`, `Section`, `Assessment(Plan/Result)`, `Invoice`, `Payment(Transaction)`, `MakeupExam`.
- **APIs**
  - Internal REST routes in `config/routes.rb`.
  - External: Moodle via `moodle_rb` (configure endpoint/token via env).
- **Data flow diagrams**
  - See `docs/diagrams/dfd.md` (Level-0, Level-1, Level-2 diagrams).
- **Architecture diagram**
  - See `docs/architecture.md` for a textual overview; ERD can be generated via rails-erd (optional).

## 6. Administration & Maintenance

- **Monitoring & logging**
  - Rails logs under `log/`; add APM/log shipping as needed.
- **Backup & recovery**
  - Database: regular PostgreSQL backups (pg_dump) and tested restore runbooks.
  - Uploaded files: ensure ActiveStorage backend backups (if configured).
- **Scaling**
  - Horizontal app scaling behind a load balancer; externalize session store if needed.
  - Background workers scaled by queue depth.
  - Database: read replicas or vertical scaling; add indexes as needed.
- **Upgrades & patching**
  - Use dependabot or scheduled gem updates; run test suite and smoke tests.

## 7. Security & Compliance

- **Authentication & authorization**
  - Devise for login/registration; CanCanCan enforces permissions (see `Ability`).
- **Data protection**
  - TLS termination in production; enforce SSL at app/proxy.
  - Secrets via environment variables/Rails credentials. Do not commit secrets.
- **Compliance**
  - If handling PII, align with GDPR best practices (data minimization, right to delete, DSR processes).
- **Vulnerability management**
  - Regular gem updates, `bundler audit`/Snyk, and security testing.

See also: `docs/security.md`.

## 8. Testing & Quality Assurance

- **Strategy**
  - RSpec for unit, request, and controller specs in `spec/`.
  - Add feature/system specs for high-value flows.
- **Execution**
  ```bash
  bundle exec rspec
  ```
- **Static analysis**
  - RuboCop for style/lints; optional CI integration.
- **Known issues/limitations**
  - wkhtmltopdf rendering quirks (print CSS/JS timing). Consider pre-rendered SVGs for diagrams.

See also: `docs/testing.md`.

## 9. Troubleshooting & FAQs

- **Common errors**
  - pg compile errors → install PostgreSQL client headers; ensure `pg_config` on PATH.
  - Bundler mismatch → install `bundler:2.4.13` per `Gemfile.lock`.
  - wkhtmltopdf not found → install binary or set `WKHTMLTOPDF_BINARY`.
  - Redis/Sidekiq connection → set `REDIS_URL` or start Redis.
- **Logs & error codes**
  - Check `log/development.log` and server logs; Sidekiq logs STDOUT/process manager.
- **FAQ**
  - Where are routes? → `config/routes.rb`.
  - How to generate docs PDF? → `bundle exec rake docs:build_pdf`.

See also: `docs/troubleshooting.md`.

## 10. Appendices

- **References & resources**
  - Ruby on Rails Guides, ActiveAdmin, Devise, CanCanCan, Sidekiq, WickedPDF, Prawn
- **Version history / change log**
  - Track in VCS and release notes; current Ruby `3.1.2`, Rails `7.0.8.4`.
- **Contact & support**
  - Project maintainers per organization. For credentials and environment, contact ops/IT.
