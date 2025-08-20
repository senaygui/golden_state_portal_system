class Section < ApplicationRecord
   belongs_to :program
   has_many :students
   has_many :grade_reports
   has_many :semester_registrations
   has_many :course_registrations
   has_many :grade_changes
   has_many :course_instructors
   has_many :attendances, dependent: :destroy
   has_many :withdrawals
   has_many :recurring_payments
   has_many :add_and_drops
   has_many :makeup_exams
   has_many :class_schedules
   has_many :exam_schedules
   # #scope
   scope :by_program, ->(program_id) { where(program_id:) }

    scope :instructor_courses, ->(user_id) { CourseInstructor.where(admin_user_id: user_id).pluck(:section_id) }
    scope :instructors, lambda { |user_id|
                          CourseInstructor.where(section_id: instructor_courses(user_id)).pluck(:course_id)
                        }

     # #validations
    validates :section_short_name, presence: true, uniqueness: true
    validates :section_full_name, presence: true, uniqueness: true
    validates :year, presence: true
    validates :semester, presence: true

    # auto-generate full name for consistency
    before_validation :set_section_full_name
    # auto-generate short name for consistency
    before_validation :set_section_short_name

  enum section_status: {
     empty: 0,
     partial: 1,
     full: 2
  }

    private

    def set_section_full_name
      return if program.blank? || program.program_name.blank? || batch.blank? || year.blank? || semester.blank?

      prog = program.program_name.to_s.strip
      b = batch.to_s.strip
      y = year.to_s.strip
      s = semester.to_s.strip

      # Base title without section suffix
      base = "#{prog} - #{b} batch - Year #{y} - Semester #{s}"

      # Only (re)generate when creating, when blank, or when base changed
      if new_record? || section_full_name.blank? || !section_full_name.start_with?(base)
        next_n = next_section_number
        self.section_full_name = "#{base} - section #{next_n}"
      end
    end

    def set_section_short_name
      return if program.blank? || program.program_name.blank? || batch.blank? || year.blank? || semester.blank?

      prog = program.program_name.to_s.strip
      b = batch.to_s.strip
      y = year.to_s.strip
      s = semester.to_s.strip

      # Compact base without section suffix
      base_short = "#{prog} - #{b} - Y#{y}S#{s}"

      # Only (re)generate when creating, when blank, or when base changed
      if new_record? || section_short_name.blank? || !section_short_name.start_with?(base_short)
        next_n = next_section_number
        self.section_short_name = "#{base_short} - section #{next_n}"
      end
    end

    def next_section_number
      scope = Section.where(program_id: program_id, batch: batch, year: year, semester: semester)
      scope = scope.where.not(id: id) if id.present?

      max_n = 0
      scope.pluck(:section_full_name, :section_short_name).each do |full, short|
        [full, short].compact.each do |name|
          # Match patterns like "- section 3" or compact forms like "- S3" if ever used
          if (m = name.to_s.match(/\bsection\s(\d+)\b/i))
            n = m[1].to_i
            max_n = n if n > max_n
          elsif (m2 = name.to_s.match(/\bS(?:ec(?:tion)?)?\s?(\d+)\b/i))
            n2 = m2[1].to_i
            max_n = n2 if n2 > max_n
          end
        end
      end

      max_n + 1
    end
end
