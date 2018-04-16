class DefaultUser < ActiveRecord::Migration[5.1]
  def up
    admin = User.new
    admin.username = "admin123"
    admin.email = "admin@example.com"
    admin.phone = "1231231234"
    admin.password = "secret"
    admin.password_confirmation = "secret"
    admin.role = "admin"
    admin.save
    
    
    adminInstructor = Instructor.new
    adminInstructor.user = admin
    adminInstructor.first_name = "Admin"
    adminInstructor.last_name = "User" 
    adminInstructor.bio = "I run the show!"
    adminInstructor.save

  end
  def down
    adminInstructor = Instructor.find_by_bio "I run the show!"
    Instructor.delete adminInstructor
    admin = User.find_by_email "admin@example.com"
    User.delete admin

  end
end
