# Extend the Rails ApplicationController to define some RESTful endpoints for
# dealing with Announcements.
class AnnouncementsController < ApplicationController
  before_action :set_announcement, except: [:index, :new, :create]

  action_auth_level :index, :instructor
  def index
    if @cud.user.administrator?
      @announcements = Announcement.where("course_id=? or system", @course.id)
    else
      @announcements = @course.announcements
    end
  end

  action_auth_level :new, :instructor
  def new
    @announcement = @course.announcements.new
  end

  action_auth_level :create, :instructor
  def create
    @announcement = @course.announcements.new(announcement_params)

    if @announcement.save
      flash[:success] = "Announcement Created"
      redirect_to(action: :index) && return
    else
      flash[:error] = "Error Creating Announcement"
      redirect_to(action: :new) && return
    end
  end

  action_auth_level :edit, :instructor
  def edit
  end

  action_auth_level :update, :instructor
  def update
    if @announcement.update(announcement_params)
      flash[:success] = "Announcement Successfully Edited"
      redirect_to(action: :index) && return
    else
      flash[:error] = "Error Editing Announcement"
      redirect_to(action: :edit) && return
    end
  end

  action_auth_level :destroy, :instructor
  def destroy
    if @announcement.destroy
      flash[:success] = "Announcement Deleted"
      redirect_to(action: :index) && return
    else
      flash[:error] = "Error Deleting Announcement"
      redirect_to(action: :edit) && return
    end
  end

private

  def set_announcement
    @announcement = @course.announcements.find(params[:id])
    return unless @announcement.system && !@cud.user.administrator?

    flash[:error] = "You don't have permission to access system announcments."
    redirect_to(action: :index) && return
  end

  def announcement_params
    params.require(:announcement).permit(:title, :description, :start_date,
                                         :end_date, :system, :persistent)
  end
end
