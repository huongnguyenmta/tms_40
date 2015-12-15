class UsersCourse < ActiveRecord::Base

  ASSIGN_TYPE = {
    supervisor: "supervisor",
    trainee: "trainee"
  }

  after_create :appened_assigned_users
  after_destroy :appened_removed_users

  belongs_to :user
  belongs_to :course

  scope :supervisors, ->{ where supervisor: true }
  scope :trainees, ->{ where supervisor: false }

  def appened_assigned_users
    course.assigned_users << user
  end

  def appened_removed_users
    course.removed_users << user
  end
end