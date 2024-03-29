require 'set'

class Instructor < ApplicationRecord
  include AppHelpers::Activeable::InstanceMethods
  extend AppHelpers::Activeable::ClassMethods
  mount_uploader :photo, PhotoUploader
    
  # relationships
  belongs_to :user
  has_many :camp_instructors
  has_many :camps, through: :camp_instructors
  
  attr_accessor :username, :password, :password_confirmation, :email, :phone

  # validations
  validates_presence_of :first_name, :last_name

  # scopes
  scope :alphabetical, -> { order('last_name, first_name') }
  scope :needs_bio, -> { where(bio: nil) }
  scope :current, -> { joins(:camps).where("start_date <= ? and end_date >= ?", Date.today, Date.today) }

  # class methods
  def self.for_camp(camp)
    # the 'instructive way'... (which I told you if you asked me for help)
    CampInstructor.where(camp_id: camp.id).map{ |ci| ci.instructor }
    # the easy way... 
    # camp.instructors
  end
  
  def self.not_for_camp(camp)
    # the 'instructive way'... (which I told you if you asked me for help)
    structs = Set.new
    for instructor in Instructor.active.alphabetical
      structs << instructor 
    end
    for assignment in CampInstructor.for_camp(camp)
      structs.delete(assignment.instructor)
    end
    return structs
  end
  
  
  def self.not_for_date(start_date, timeslot)
    structs = Set.new
    for stud in Instructor.active.alphabetical
      structs << stud 
    end
    for ci in CampInstructor.all
      if ci.camp.start_date == start_date && ci.camp.time_slot == timeslot
        structs.delete(ci.instructor)
      end
    end
    return structs
  end
  

  # delegates
  delegate :email, to: :user, allow_nil: true
  delegate :phone, to: :user, allow_nil: true
  delegate :username, to: :user, allow_nil: true

  # callbacks
  before_update :deactive_user_if_instructor_inactive

  before_destroy do
    check_if_instructor_taught_past_camps
    if errors.present?
      @destroyable = false
      throw(:abort)
    else
      destroy_user_account
    end
  end

  after_rollback :convert_to_inactive_and_remove_upcoming_camps

  # instance methods
  def name
    last_name + ", " + first_name
  end
  
  def proper_name
    first_name + " " + last_name
  end

  private
  def deactive_user_if_instructor_inactive
    if !self.active && !self.user.nil?
      self.user.active = false
      self.user.save
    end
  end

  def check_if_instructor_taught_past_camps
    unless self.camps.past.empty?
      errors.add(:base, 'You are not allowed to delete this instructor because he/she tuaght past camps.')
    end
  end

  def destroy_user_account
    self.user.destroy
  end

  def convert_to_inactive_and_remove_upcoming_camps
    if @destroyable == false
      remove_upcoming_camps
      self.make_inactive
    end
    @destroyable = nil
  end

  def remove_upcoming_camps
    self.camp_instructors.select{|ci| ci.camp.start_date >= Date.current}.each{|ci| ci.destroy}
  end

end