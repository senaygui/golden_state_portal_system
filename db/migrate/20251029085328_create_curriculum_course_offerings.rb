class CreateCurriculumCourseOfferings < ActiveRecord::Migration[7.0]
  def change
    create_table :curriculum_course_offerings, id: :uuid do |t|
      t.belongs_to :program, null: false, foreign_key: true, type: :uuid
      t.string :batch, null: false
      t.belongs_to :curriculum, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
