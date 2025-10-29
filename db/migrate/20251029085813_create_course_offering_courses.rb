class CreateCourseOfferingCourses < ActiveRecord::Migration[7.0]
  def change
    create_table :course_offering_courses, id: :uuid do |t|
      t.belongs_to :course, null: false, foreign_key: true, type: :uuid
      t.belongs_to :curriculum_course_offering, null: false, foreign_key: true, type: :uuid
      t.integer :year
      t.integer :semester

      t.timestamps
    end
  end
end
