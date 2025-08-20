ActiveAdmin.register StudentRequestSetting do
  menu priority: 1, label: 'Student Request Settings'
  actions :all

  permit_params :allow_grade_change, :allow_makeup_exam, :allow_add_course, :allow_drop_course

  controller do
    def index
      redirect_to edit_resource_path(StudentRequestSetting.current)
    end

    def show
      redirect_to edit_resource_path(StudentRequestSetting.current)
    end

    def new
      redirect_to edit_resource_path(StudentRequestSetting.current)
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs 'Student Request Toggles' do
      f.input :allow_grade_change, label: 'Allow Grade Change Requests'
      f.input :allow_makeup_exam, label: 'Allow Makeup Exam Requests'
      f.input :allow_add_course, label: 'Allow Add Course Requests'
      f.input :allow_drop_course, label: 'Allow Drop Course Requests'
    end
    f.actions
  end

  show do
    attributes_table do
      row :allow_grade_change
      row :allow_makeup_exam
      row :allow_add_course
      row :allow_drop_course
      row :updated_at
    end
    active_admin_comments
  end
end
