class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities


    user ||= User.new # guest user

    # TO ALL REGISTERED
    if user.persisted? #Applies to all registered
      can [:edit, :update], Profile do |p|
        p.user == user
      end
      
      can :show, Profile
    end

    # ROLE BASED STUFF
    if user.is_a? Admin

      can :do_admin_stuff, :stuff
      can :manage, :all
      cannot :see_user, User do |u|
        if u == user.userize
          true
        else
          false
        end
      end

    elsif user.is_a? Teacher

      can :do_teacher_stuff, :stuff
      can :manage, Student

    elsif user.is_a? Technician

      can :do_technician_stuff, :stuff

    elsif user.is_a? Student

      can :do_student_stuff, :stuff

    else #VISITOR - Unregistered
    end

  end

end
