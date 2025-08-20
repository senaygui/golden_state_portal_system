class AddCoursesController < ApplicationController
  before_action :authenticate_student!, only: [:set_preferred_section]
  before_action :ensure_add_course_allowed!, only: [:index]
  def index
    #@next_courses = []
    #@added_courses = []
    @course_having_f = StudentGrade.where(student: current_student).where('f_counter <= 2').where(letter_grade: 'F').or( StudentGrade.where(student: current_student).where(letter_grade: 'f')).includes(:course)
    @courses = Dropcourse.drop_course_approved.or(Dropcourse.drop_course_applied).includes(:course)
    if current_student.semester == 1
     @next_courses = Course.where(program_id: current_student.program_id).where("year >= ?", current_student.year).where(semester: 2)
    else
      @next_courses = Course.where(program_id: current_student.program_id).where("year > ?", current_student.year)
    end
    @added_courses = AddCourse.approved.where(student_id: current_student.id).includes(:course).includes(:department)
    #@added_courses + @next_courses
    current_total_credit_hour = CourseRegistration.where(student: current_student, semester: current_student.semester, year: current_student.year).includes(:course).active_yes.sum {|c| c.course.credit_hour}
    if current_student.admission_type == 'regular' && current_student.study_level == "undergraduate"
      @allowed_credit_hour = 22 - current_total_credit_hour
    elsif current_student.admission_type == 'extension' && current_student.study_level == "undergraduate"
      @allowed_credit_hour = 13 - current_total_credit_hour
    elsif current_student.admission_type == "regular" && current_student.study_level == "graduate"
      @allowed_credit_hour = 12 - current_total_credit_hour
    end
  end

  # PATCH /add_courses/:id/preferred_section
  def set_preferred_section
    add_course = AddCourse.find(params[:id])
    unless add_course.student_id == current_student.id
      return redirect_to add_courses_path, alert: 'Not authorized'
    end

    unless add_course.approved?
      return redirect_to add_courses_path, alert: 'Only approved requests can set a preferred section.'
    end

    section = Section.find_by(id: params[:section_id])
    return redirect_to add_courses_path, alert: 'Invalid section selected.' if section.nil?

    # allowed = section.program_id == current_student.program_id &&
    #           section.year == add_course.year &&
    #           section.semester == add_course.semester &&
    #           section.batch.to_s == current_student.batch.to_s

    # return redirect_to add_courses_path, alert: 'Selected section is not available for you.' unless allowed

    if add_course.update(preferred_section_id: section.id)
      redirect_to add_courses_path, notice: 'Preferred section saved.'
    else
      redirect_to add_courses_path, alert: 'Could not save preferred section.'
    end
  end

  private

  def ensure_add_course_allowed!
    unless StudentRequestSetting.current.allow_add_course
      redirect_to root_path, alert: 'Add course requests are currently disabled.'
    end
  end
end
