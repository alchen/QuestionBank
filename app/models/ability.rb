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
    alias_action :prepare_quiz, :generate_quiz, :show_quiz, :to => :quiz
    user ||= User.new # guest user (not logged in)
    can :manage, User, :id => user.id # allow the user to change its own profile
    if user.has_role? :admin
        can :manage, :all
    else
        can :read, UserGroup, :id => UserGroup.with_role(:viewer, user).map{ |group| group.id }
        can :manage, UserGroup, :id => UserGroup.with_role(:owner, user).map{ |group| group.id }
        can :manage, Attempt, :id => UserGroup.with_role([:owner, :viewer], user).map{ |group| group.attempts.map{|attempt| attempt.id } }.flatten.uniq
        # can :read, QuestionGroup, :id => QuestionGroup.with_role(:viewer, user).map{ |group| group.id }
        # can :manage, QuestionGroup, :id => QuestionGroup.with_role(:owner, user).map{ |group| group.id }
        can :manage, QuestionGroup
        can :read, Tag
        can :manage, Question
        cannot :quiz, Question
        can :read, User, :id => UserGroup.with_role([:owner, :viewer], user).map{|group| group.users.map{|user| user.id } }.flatten.uniq
    end
  end
end
