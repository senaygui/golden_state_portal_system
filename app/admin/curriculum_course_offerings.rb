ActiveAdmin.register CurriculumCourseOffering do
  menu parent: "Program", label: "Curriculum Course Offerings"

  permit_params :batch, :program_id, :curriculum_id,
                course_offering_courses_attributes: [:id, :course_id, :year,:semester,  :_destroy]

  index do
    selectable_column
    column :program do |cco|
      link_to cco.program.program_name, [:admin, cco.program] if cco.program
    end
    column :curriculum do |cco|
      link_to cco.curriculum.curriculum_title, [:admin, cco.curriculum] if cco.curriculum
    end
    column("Courses") { |cco| cco.courses.count }
    column :created_at
    actions
  end

  filter :program_id, as: :search_select_filter, url: proc { admin_programs_path },
                      fields: [:program_name, :id], display_name: 'program_name', minimum_input_length: 2,
                      order_by: 'id_asc'
  filter :curriculum_id, as: :search_select_filter, url: proc { admin_curriculums_path },
                         fields: [:curriculum_title, :id], display_name: 'curriculum_title', minimum_input_length: 2,
                         order_by: 'id_asc'

  form do |f|
    f.semantic_errors

    f.inputs "Association" do
      f.input :program_id, as: :search_select, url: admin_programs_path,
              fields: [:program_name, :id], display_name: 'program_name', minimum_input_length: 2,
              order_by: 'id_asc'
      f.input :curriculum_id, as: :search_select, url: admin_curriculums_path,
              fields: [:curriculum_title, :id], display_name: 'curriculum_title', minimum_input_length: 2,
              order_by: 'id_asc'
      f.input :batch, as: :select, collection: [
                '2019/2020',
                '2020/2021',
                '2021/2022',
                '2022/2023',
                '2023/2024',
                '2024/2025',
                '2025/2026',
                '2026/2027',
                '2027/2028',
                '2028/2029',
                '2029/2030'
              ], include_blank: false

    end

    panel "Courses in this Offering" do
      f.has_many :course_offering_courses, allow_destroy: true, new_record: true do |c|
        c.input :course_id, as: :search_select, url: admin_courses_path,
                fields: [:course_title, :id], display_name: 'course_title', minimum_input_length: 2,
                order_by: 'id_asc'
        c.input :year
        c.input :semester
      end
    end

    f.actions
  end

  show title: :batch  do
    tabs do
      tab "#{curriculum_course_offering.batch}" do
        attributes_table do
          row :program do |cco|
            link_to cco.program.program_name, [:admin, cco.program] if cco.program
          end
          row :curriculum do |cco|
            link_to cco.curriculum.curriculum_title, [:admin, cco.curriculum] if cco.curriculum
          end
          row :created_at
          row :updated_at
        end
      end
      tab "Course Breakdown" do      
        panel "Course Breakdown list" do
          (1..curriculum_course_offering.program.program_duration).map do |i|
            panel "ClassYear: Year #{i}" do
              (1..curriculum_course_offering.program.program_semester).map do |s|
                panel "Semester: #{s}" do
                  table_for curriculum_course_offering.course_offering_courses.where(year: i, semester: s).order('year ASC','semester ASC') do
                    ## TODO: wordwrap titles and long texts
                    # year
                    # Semester
                    # Curri_id 
                    # study_level
                    # admission_type 
                    # total
                    column "course title" do |item|
                      link_to item.course.course_title, [ :admin, item.course] 
                    end
                    column "module code" do |item|
                      item.course.course_module.module_code
                    end
                    column "course code" do |item|
                      item.course.course_code
                    end
                    column "credit hour" do |item|
                      item.course.credit_hour
                    end
                    column :lecture_hour do |item|
                      item.course.lecture_hour
                    end
                    column :lab_hour do |item|
                      item.course.lab_hour
                    end
                    column "contact hr." do |item|
                      item.course.ects
                    end
                    column "Course Type" do |item|
                      status_tag item.course.course_type, 
                                 class: {
                                   "common" => "status-ok",
                                   "major" => "status-warning",
                                   "elective" => "status-info",
                                   "supportive" => "status-error"
                                 }[item.course.course_type]
                    end
                    # column :last_updated_by
                    column "Add At", sortable: true do |c|
                      c.created_at.strftime("%b %d, %Y")
                    end
                    # column "Starts at", sortable: true do |c|
                    #   c.course_starting_date.strftime("%b %d, %Y") if c.course_starting_date.present?
                    # end
                    # column "ends At", sortable: true do |c|
                    #   c.course_ending_date.strftime("%b %d, %Y") if c.course_ending_date.present?
                    # end
                  end
                end
              end      
            end 
          end    
        end 
      end
    end
  end

  action_item :copy_courses, only: :show do
    link_to 'Copy Courses from Curriculum',
            copy_courses_admin_curriculum_course_offering_path(resource),
            method: :post,
            data: { confirm: 'Copy all courses from the associated Curriculum into this offering? Existing courses will be skipped.' }
  end

  member_action :copy_courses, method: :post do
    cco = CurriculumCourseOffering.find(params[:id])
    unless cco.curriculum
      redirect_to admin_curriculum_course_offering_path(cco), alert: 'No curriculum associated to copy from.' and return
    end

    copied = 0
    skipped = 0
    cco.curriculum.courses.find_each do |crs|
      if cco.course_offering_courses.exists?(course_id: crs.id)
        skipped += 1
      else
        cco.course_offering_courses.create!(course_id: crs.id, year: crs.year, semester: crs.semester)
        copied += 1
      end
    end

    notice = "Copied #{copied} course(s)."
    notice += " Skipped #{skipped} existing." if skipped.positive?
    redirect_to admin_curriculum_course_offering_path(cco), notice: notice
  end
end
