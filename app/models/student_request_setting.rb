class StudentRequestSetting < ApplicationRecord
  # Singleton accessor
  def self.current
    first_or_create!(
      allow_grade_change: true,
      allow_makeup_exam: true,
      allow_add_course: true,
      allow_drop_course: true
    )
  rescue ActiveRecord::StatementInvalid, ActiveRecord::NoDatabaseError, ActiveRecord::ConnectionNotEstablished
    # Return a lightweight struct with permissive defaults until migrations run
    Struct.new(:allow_grade_change, :allow_makeup_exam, :allow_add_course, :allow_drop_course)
          .new(true, true, true, true)
  end

  def all_approvals_required?
    true
  end
end
