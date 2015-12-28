class Supervisor::CoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_course, except: [:index, :new, :create]
  before_action :check_course_before_update, only: :update
  before_action :check_course_before_destroy, only: :destroy
  load_and_authorize_resource only: [:edit, :update, :destroy]

  def index
    @search = current_user.courses.search params[:q]
    @courses = @search.result.paginate page: params[:page], per_page: 10
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new course_params
    if @course.save
      flash[:notice] = t "flash_course_created"
      redirect_to supervisor_course_path @course
    else
      render :new
    end
  end

  def show
    @activities = @course.load_activities
  end

  def edit
  end

  def update
    if course_params.has_key? :update_status
      @course.update_status!
      if @course.started?
        flash[:success] = t ".success", action: "Started"
      else
        flash[:success] = t ".success", action: "Finished"
      end
      redirect_to supervisor_course_path @course
    elsif @course.update_attributes course_params
      flash[:success] = t ".success", action: "Updated"
      redirect_to supervisor_course_path @course
    else
      render :edit
    end
  end

  def destroy
    @course.destroy
    flash[:success] = t ".course_delete"
    redirect_to supervisor_courses_path
  end

  private
  def load_course
    @course = Course.find params[:id]
  end

  def course_params
    params.require(:course).permit :name, :description, :start_date, :end_date,
      :update_status, subject_ids: []
  end  

  def check_course_before_update
    if @course.invalid_for_update? course_params.has_key?(:update_status)
      flash[:danger] = t ".danger"
      redirect_to supervisor_courses_path
    end
  end

  def check_course_before_destroy
    unless @course.finished?
      flash[:danger] = t ".danger"
      redirect_to supervisor_courses_path
    end
  end
end