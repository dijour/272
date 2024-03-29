class User < ApplicationRecord
  # use has_secure_password for password hashing
  has_secure_password
  
  # relationships
  has_one :family
  has_one :instructor
  
  # scopes
  scope :alphabetical, -> { order('username') }

  # validations
  validates :username, presence: true, uniqueness: { case_sensitive: false}
  validates :role, inclusion: { in: %w[admin instructor parent], message: "is not a recognized role in system" }
  validates_presence_of :password, on: :create 
  validates_presence_of :password_confirmation, on: :create 
  validates_confirmation_of :password, message: "does not match"
  validates_length_of :password, minimum: 4, message: "must be at least 4 characters long", allow_blank: true
  validates_format_of :phone, with: /\A\(?\d{3}\)?[-. ]?\d{3}[-.]?\d{4}\z/, message: "should be 10 digits (area code needed) and delimited with dashes or dots"
  validates_format_of :email, with: /\A[\w]([^@\s,;]+)@(([\w-]+\.)+(com|edu|org|net|gov|mil))\z/i, message: "is not a valid format"

  # callbacks
  before_save :reformat_phone

  # for use in authorizing with CanCan
  ROLES = [['Admin', :admin],['Instructor', :instructor],['Parent', :parent]]

  def self.authenticate(email,password)
    find_by_email(email).try(:authenticate, password)
  end

  def role?(authorized_role)
    return false if role.nil?
    role.to_sym == authorized_role
  end
    
  def name
    if Instructor.where(user: self).size == 1
      return Instructor.where(user: self).first.proper_name
    elseif Family.where(user: self).size == 1
      fam = Family.where(user: self).first
      return "#{fam.parents_first_name}, #{fam.name}"
    else
      return
    end
  end

  private
  def reformat_phone
    self.phone = self.phone.to_s.gsub(/[^0-9]/,"")
  end

end
