class CreateStudentRequestSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :student_request_settings do |t|
      t.boolean :allow_grade_change, null: false, default: true
      t.boolean :allow_makeup_exam, null: false, default: true
      t.boolean :allow_add_course, null: false, default: true
      t.boolean :allow_drop_course, null: false, default: true
      t.timestamps
    end
  end
end
