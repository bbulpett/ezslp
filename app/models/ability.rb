class Ability
  include CanCan::Ability
  
  def initialize(user)
    can :manage, :all if user.admin?
    #can :calendar if user.admin?
  end
end
