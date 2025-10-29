# Data Model Notes

Key models and responsibilities (non-exhaustive):

- `Student` — authentication, profile, enrollments, grades
- `SemesterRegistration` — registration lifecycle, fees, invoices
- `Course`, `CourseModule`, `Section` — curriculum and delivery structure
- `AssessmentPlan`, `Assessment`, `AssessmentResult`, `StudentGrade`, `GradeReport` — evaluation and reporting
- `Invoice`, `Payment`, `PaymentTransaction`, `PaymentMethod` — billing and payments
- `MakeupExam`, `Readmission`, `ExternalTransfer`, `ProgramExemption`, `Exemption` — student lifecycle exceptions
- `AcademicCalendar`, `ClassSchedule`, `ExamSchedule` — timelines and schedules
- `Notice`, `DocumentRequest` — communications and official documents
- `AdminUser`, `Ability` — admin and authorization

See `app/models/` for the full list. Start with:
- `app/models/semester_registration.rb` (complex domain logic)
- `app/models/student.rb`
- `app/models/student_grade.rb`
- `app/models/makeup_exam.rb`
