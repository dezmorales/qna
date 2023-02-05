class RewardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @rewards = Reward.where(user: current_user)
  end
end
