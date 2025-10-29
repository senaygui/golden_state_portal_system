class CurriculumCourseOffering < ApplicationRecord
  belongs_to :program
  belongs_to :curriculum
  has_many :course_offering_courses, dependent: :destroy
  has_many :courses, through: :course_offering_courses
   accepts_nested_attributes_for :course_offering_courses, reject_if: :all_blank, allow_destroy: true
end
