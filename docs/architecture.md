# Architecture

## Layers

- Controllers (`app/controllers/`): RESTful endpoints for students, courses, registrations, payments, reports, etc.
- Models (`app/models/`): ActiveRecord; key domain models include `Student`, `SemesterRegistration`, `Course`, `Invoice`, `Assessment`, `MakeupExam`.
- Views (`app/views/`): ERB templates; PDFs rendered via wicked_pdf or Prawn.
- Admin (`app/admin/`): ActiveAdmin resources for administration.
- Services (`app/services/`): encapsulated domain operations.
- PDFs (`app/pdfs/`): Prawn PDF builders.

## Authentication & Authorization

- Devise for `Student` and `AdminUser`.
- CanCanCan (`Ability`) centralizes permissions (`app/models/ability.rb`).

## Routing

- See `config/routes.rb` for comprehensive routes including:
  - Course management, assessments, assessment plans, results
  - Semester registrations, add/drop, transfers, readmissions
  - Document requests with payment and receipt upload
  - Reports (grade, student, payment, course assignments)
  - Admin namespaces for registration payments, sections, schedules

## Data storage

- PostgreSQL primary data store.
- ActiveStorage enabled with validations; drag-and-drop support included.

## Background jobs

- Sidekiq with Redis.

## PDFs

- WickedPDF + wkhtmltopdf for HTML-based PDFs.
- Prawn + prawn-table for programmatic PDFs.
