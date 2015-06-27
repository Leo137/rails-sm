class Ability
  include CanCan::Ability

  def initialize(user)
    
    if user != nil then
        if user.admin?
          can :manage, :all
        else
          can :update_score_get, :all
          can :friend_request_post, :all
          can :friend_request_show, :all
          can :friend_request_put, :all
          can :friend_request_delete, :all
          can :propose_song_show, :all
          can :propose_song_post, :all
          can :propose_song_delete, :all
          can :join_league_post, :all
          can :join_league_delete, :all
          can :publish_comment_post, :all
          can :publish_comment_delete, :all
        end
    end
    user ||= User.new # guest user (not logged in)
    can :index, :all
    can :show, :all
    can :index_rank, :all
    can :publish_comment_show, :all
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
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
  end
end
