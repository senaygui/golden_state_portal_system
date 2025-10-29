# System Overview

This repository contains a Ruby on Rails application for an Online Learning Management System (LMS).

- Application name: `PortalSystem`
- Ruby: 3.1.2
- Rails: 7.0.8.4 (config defaults set to 5.2 in `config/application.rb`)
- Database: PostgreSQL
- App server: Puma
- Admin UI: ActiveAdmin
- Auth: Devise (students, admin_users)
- Authorization: CanCanCan
- Background jobs: Sidekiq
- PDFs: wicked_pdf + wkhtmltopdf, Prawn
- Frontend: Sprockets pipeline, Turbolinks, jQuery, Bootstrap 4.6

Key directories:
- `app/controllers/` — REST controllers (students, courses, registrations, payments, reports, etc.)
- `app/models/` — ActiveRecord models (e.g., `Student`, `SemesterRegistration`, `Course`, `Invoice`, `MakeupExam`)
- `app/views/` — ERB views for all features
- `app/admin/` — ActiveAdmin resources
- `app/services/` — service objects for domain tasks
- `config/routes.rb` — comprehensive routing configuration

Major features (non-exhaustive):
- Student authentication and profile management
- Semester registration and course add/drop
- Assessments and grade reporting (including online approval and PDF exports)
- Document requests and payments
- Make-up exams, readmissions, transfers, exemptions
- Academic calendar, notices, class and exam schedules
- Admin dashboards and batch operations (ActiveAdmin)
