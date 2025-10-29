# Routes Highlights

See `config/routes.rb` for full details. Notable endpoints:

- Root: `GET /` => `pages#home`
- Student auth: Devise routes under `/students`
- Admin: ActiveAdmin under `/admin`
- Semester registration:
  - `GET /new/semester/registration` => `pages#enrollement`
  - `POST /create/semester/registration` => `pages#create_semester_registration`
- Assessments:
  - `resources :assessment_plans` nested under `courses`
  - `resources :assessmens` with collection routes: `bulk_create`, `find_course`, `missing_assessments_report`
- Documents:
  - `resources :document_requests` with `payment`, `upload_receipt`, `track_form`, `track`
- Reports:
  - `GET /course_assignments` => `reports#course_assignments`
  - Multiple student and payment reports under `student_report_*` and `payment_report_*`
- Payments & invoices:
  - `resources :invoices`, `payment_methods`, `payment_transactions`
- Exceptions:
  - `resources :makeup_exams` with `payment`, `verify`
  - `resources :readmissions` with `payment`, `verify`
  - `resources :external_transfers` with `filter_programs`, `payment`
