class UsersSubject < ActiveRecord::Base
  STATUS = {
    new: 0,
    started: 1,
    finished: 2
  }

  belongs_to :user
  belongs_to :courses_subject
  belongs_to :subject
  scope :finished, ->{where status: STATUS[:finished]}

  def self.find_by_user(user_id)
    UsersSubject.find_by("user_id = ?", user_id)
  end

  def new?
    status == STATUS[:new]
  end

  def started?
    status == STATUS[:started]
  end

  def finished?
    status == STATUS[:finished]
  end
end
