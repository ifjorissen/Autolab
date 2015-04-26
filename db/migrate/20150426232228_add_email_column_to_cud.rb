class AddEmailColumnToCud < ActiveRecord::Migration
  def change
    add_column :course_user_data, :email, :string
    CourseUserDatum.find_each do |cud|
      cud.email = cud.user.email
      cud.save
    end
  end
end
