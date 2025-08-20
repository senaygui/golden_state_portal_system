class AddApprovalMinToMakeupExams < ActiveRecord::Migration[6.0]
  def change
    add_column :makeup_exams, :approval_min, :datetime
  end
end
