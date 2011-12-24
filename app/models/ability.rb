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
    # This applies to everyone --whitelist
    can :read, Course
    # end of everyone --whitelist
    if @user.persisted? #Applies to all registered -- whitelist
      can [:edit, :update], Profile do |p|
        p.user == @user
      end
      can_see_others
      can_api
    end

    # ROLE BASED STUFF
    if @user.is_a? Admin

      can :do_admin_stuff, :stuff
      can :manage, :all
      #cannot :registrar, Course

    elsif @user.is_a? Teacher

      can :do_teacher_stuff, :stuff
      can :manage, Practica do |practica|
        practica.users.include? @user
      end

      can :control, :course
      can :manage, Course do |course|
        course.users.include? @user
      end

      can_register_in_course

      cannot :create, Course
      cannot :destroy, Course
      cannot :assign_teacher, Course

    elsif @user.is_a? Technician

      can :do_technician_stuff, :stuff
      can :manage, Puerto
      can :manage, Dispositivo
      can :manage, DeviceConnection
      can :manage, Practica

      cannot :destroy, Practica do |practica|
        practica.abierta?
      end

    elsif @user.is_a? Student

      can :do_student_stuff, :stuff
      can :read, Student
      # Manage himself
      can :manage, [User, Student] do |uos|
        uos.id.eql? @user.id
      end

      # Practice things over here
      can_do_normal_labs

      can :see_users, Course do |course|
        course.users.include? @user
      end

      # Is any of the courses shared with student?
      can :see_details, [Student, User] do |uos|
        @user.courses.any? {|course| course.users.include? uos}
      end

      can_register_in_course
      can :read, Course
      can_detail_practices

      cannot :destroy, [User, Student]

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

  def can_api
    can :json_users, User
  end

  def can_register_in_course
    can :register, Course
    can :unregister, Course do |course|
      course.users.include? @user
    end
  end

  # Very specific, use can_do_normal_labs instead
  def can_do_lab_practices
    can :make_practice, Practica do |practica|
      practica.abierta? && (practica.users.include? @user)
    end
    can :terminal, Practica do |practica|
      practica.abierta? && (practica.users.include? @user)
    end
    can :lab, Practica do |practica|
      practica.abierta? && (practica.users.include? @user)
    end
    can :chat_status, Practica do |practica|
      practica.abierta? && (practica.users.include? @user)
    end
    can :chat, Practica do |practica|
      practica.abierta? && (practica.users.include? @user)
    end
    can :new_conexion, Practica do |practica|
      practica.abierta? && (practica.users.include? @user)
    end
    can :remove_conexion, Practica do |practica|
      practica.abierta? && (practica.users.include? @user)
    end
  end

  def can_do_normal_labs

    #can :manage, Practica

    can :manage, Practica do |practica|
      practica.abierta? && (practica.users.include? @user)
    end
    cannot :manage, Practica do |practica|
      practica.cerrada?
    end
    cannot [:edit, :update], Practica do |practica|
      practica.abierta?
    end

    can [:edit, :destroy, :update], Practica do |practica|
      practica.reservada? && (practica.users.include? @user)
    end

    can [:create, :index, :read], Practica

  end

  def can_detail_practices
    can :free_devices, Practica
    can :practice_events, Practica
  end

end
