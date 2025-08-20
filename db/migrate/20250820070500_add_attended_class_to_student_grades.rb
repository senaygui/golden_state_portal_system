class AddAttendedClassToStudentGrades < ActiveRecord::Migration[6.1]
  def change
    add_column :student_grades, :attended_class, :boolean, null: false, default: true
  end
end
