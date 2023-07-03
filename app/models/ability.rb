# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    #Define admin, user and open end points access
    if user.present? && (user.has_role? :admin)
        can :manage, :all
    elsif user.present? && (user.has_role? :user)
        can :manage, [User,Parcel]
    else
      can :create, [User]
      can :read, :all
    end
  end
end
