class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_user, only: [:show, :update]

  def index
    @users = User.trainees.paginate page: params[:page], per_page: 15
  end
  def show
    @activities = @user.activities.paginate page: params[:page]
  end

  def update
    if @user.update_attributes user_params
      redirect_to course_path
    else
      render "courses_subjects/edit"
    end
  end

  private
  def load_user
    @user = User.find params[:id]
  end

  def user_params
    params.require(:user).permit task_ids: []
  end
end
