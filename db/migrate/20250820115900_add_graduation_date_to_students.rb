class AddGraduationDateToStudents < ActiveRecord::Migration[7.0]
  def change
    add_column :students, :graduation_date, :date
  end
end
