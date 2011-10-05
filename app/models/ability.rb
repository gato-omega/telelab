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
    @user = user

    # TO ALL REGISTERED --whitelist
    if @user.persisted? #Applies to all registered -- whitelist
      can [:edit, :update], Profile do |p|
        p.user == @user
      end
      can_see_others
    end

    # ROLE BASED STUFF
    if @user.is_a? Admin

      can :do_admin_stuff, :stuff
      can :manage, :all

    elsif @user.is_a? Teacher

      can :do_teacher_stuff, :stuff
      can :manage, Practica

    elsif @user.is_a? Technician

      can :do_technician_stuff, :stuff

    elsif @user.is_a? Student

      can :do_student_stuff, :stuff

    else #VISITOR - Unregistered
    end

    # TO ALL REGISTERED -- blacklist
    if @user.persisted? #Applies to all registered -- blacklist
      cannot_see_user
    end

  end

  private
  def cannot_see_user
    cannot :see, User do |u|
      u.id == @user.id
    end
  end

  def can_see_others
    can :see, User
  end

end
