class CourseOfferingCourse < ApplicationRecord
  belongs_to :course
  belongs_to :curriculum_course_offering
end
