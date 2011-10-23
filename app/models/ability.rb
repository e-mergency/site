class Ability
  include CanCan::Ability

  def initialize(user)
    if user.role? "admin"
      can :manage, :all
    else user.role? "hospital"
      can :manage, Delay 
    end

  end
end
