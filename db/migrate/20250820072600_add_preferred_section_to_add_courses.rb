class AddPreferredSectionToAddCourses < ActiveRecord::Migration[7.0]
  def change
    add_column :add_courses, :preferred_section_id, :uuid
    add_index :add_courses, :preferred_section_id
  end
end
