require 'set'

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    # user ||= User.new # guest user (not logged in)
    # if user.admin?
    #   can :manage, :all
    # else
    #   can :read, :all
    # end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
    user ||= User.new
    
    
    if user.role? :admin
      can :manage, :all
    
    elsif user.role? :instructor
      can :update, User do |uzer|  
        user.id == uzer.id
      end
      can :update, Instructor do |instructor|  
        instructor.id == user.instructor_id
      end
      can :read, Student do |student|  
        #can read students who are enrolled in camps they teach (past or upcoming)
        user.instructor.camps.registrations.include? student.id
      end
      can :read, Family do |family|
        # can read families whose students are enrolled in camps the instructor teaches
        fams = Set.new
        user.instructor.camps.registrations.each do |reg|
          set << reg.student.family
        end
        fams.include? family.id
      end
      
    elsif user.role? :parent
      can :update, Family do |family|  
        family.id == user.family_id
      end
      can :read, Family do |family|
        family.id == user.family_id
      end
      can :update, Student do |student|
        user.family.students.include? student.id
      end
      can :read, Curriculum
      can :read, Camp
      can :create, Registration do |registration|
        user.family.students.include? registration.student
      end
      can :read, Student do |student|
        user.family.students.include? student.id
      end
      
    elsif user.role.nil?
      can :create, User do |uzer|
        uzer.role == "parent"
      end
      can :read, Camp
      can :read, Curriculum
      can :read, Location
      
    end
  
  end
end
