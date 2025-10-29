# Data Flow Diagrams

This document presents data flow diagrams (DFD) for the LMS.

Note: These Mermaid diagrams render in compatible viewers (e.g., GitHub, IDE). To include rendered diagrams in the PDF, we can extend the PDF builder to initialize Mermaid during PDF generation.

## Level 0: Context Diagram

```mermaid
flowchart LR
  subgraph External_Entities
    Student([Student])
    Admin([Admin])
    PaymentGateway([Payment Gateway])
    Moodle([Moodle API])
  end

  App((PortalSystem Rails App))
  DB[(PostgreSQL)]
  Redis[(Redis / Sidekiq)]

  Student <--> App
  Admin <--> App
  App <--> PaymentGateway
  App <--> Moodle

  App <--> DB
  App <--> Redis
```

## Level 1: Major Processes

```mermaid
flowchart TB
  subgraph UI[Web UI (Controllers/Views)]
    A1[Auth & Profile]
    A2[Semester Registration]
    A3[Courses & Sections]
    A4[Assessments & Grades]
    A5[Documents & Requests]
    A6[Payments & Invoices]
    A7[Schedules & Calendar]
    A8[Admin (ActiveAdmin)]
  end

  subgraph Services[Domain Services]
    S1[PDF Generation (WickedPDF/Prawn)]
    S2[Background Jobs (Sidekiq)]
    S3[Integrations (Moodle)]
    S4[Reporting]
  end

  DB[(PostgreSQL)]
  RS[(Redis)]
  PGW([Payment Gateway])

  A1 --> DB
  A2 --> DB
  A3 --> DB
  A4 --> DB
  A5 --> DB
  A6 --> DB
  A7 --> DB
  A8 --> DB

  A5 --> S1
  A4 --> S1
  S1 --> DB

  A2 --> S2
  A4 --> S2
  A6 --> S2
  S2 <--> RS

  A6 <--> PGW

  A3 --> S3
  S3 <--> DB

  A4 --> S4
  S4 --> DB
```

## Level 2: Authentication & Profile

```mermaid
flowchart LR
  Student -->|login/register| Devise[Devise Controllers]
  Devise --> StudentModel[Student Model]
  StudentModel <--> DB[(students, profiles, attachments)]
  Devise --> Ability[CanCanCan Ability]
  Ability --> Devise
```

## Level 2: Semester Registration

```mermaid
flowchart LR
  Student --> Pages[PagesController: enrollement]
  Pages --> SR[SemesterRegistrationsController]
  SR <--> SRModel[SemesterRegistration]
  SRModel <--> DB[(semester_registrations, invoices, payments)]
  SR --> Invoices[InvoicesController]
  Invoices --> InvoiceModel[Invoice]
  InvoiceModel <--> DB
  Invoices -->|async tasks| Sidekiq
  Sidekiq <--> Redis[(Redis)]
```

## Level 2: Assessments & Grades

```mermaid
flowchart LR
  Instructor[Instructor/Admin] --> AssessCtrl[AssessmensController]
  AssessCtrl --> AssessPlanCtrl[AssessmentPlansController]
  AssessCtrl --> ResultsCtrl[AssessmentResultsController]
  AssessCtrl --> GradesCtrl[GradeReportsController]

  AssessPlanCtrl --> AssessPlan[AssessmentPlan]
  ResultsCtrl --> AssessResult[AssessmentResult]
  AssessCtrl --> Assessment[Assessment]
  GradesCtrl --> StudentGrade[StudentGrade] --> GradeReport[GradeReport]

  AssessPlan <--> DB[(courses, assessments, assessment_plans, assessment_results, student_grades)]
  Assessment <--> DB
  AssessResult <--> DB
  GradeReport <--> DB

  GradesCtrl --> PDF[PDF Service (WickedPDF/Prawn)] --> Files[(PDF output)]
```

## Level 2: Document Requests & Payments

```mermaid
flowchart LR
  Student --> DocReqCtrl[DocumentRequestsController]
  DocReqCtrl --> DocRequest[DocumentRequest]
  DocRequest <--> DB[(document_requests)]

  DocReqCtrl --> PaymentFlow[Payments]
  PaymentFlow --> InvoicesCtrl[InvoicesController]
  InvoicesCtrl --> Invoice[Invoice]
  Invoice <--> DB[(invoices, invoice_items)]

  InvoicesCtrl --> PGW[Payment Gateway]
  PGW --> PaymentTxn[PaymentTransaction]
  PaymentTxn <--> DB[(payment_transactions)]

  DocReqCtrl --> PDF[PDF Service] --> Files[(PDF output)]
```

## Level 2: Admin Operations

```mermaid
flowchart LR
  Admin --> AA[ActiveAdmin]
  AA --> AR[Admin Resources]
  AR <--> DB[(students, courses, sections, schedules, payments, etc.)]
  AA --> Reports[Reporting Services] --> DB
  AA --> Exports[Imports/Exports] --> Files[(CSV/PDF)]
```
