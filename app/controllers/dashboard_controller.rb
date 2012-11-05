class DashboardController < ApplicationController
  def index
    @users = User.get_users(current_user.organization)
    @users.sort! { |a,b| a.email.downcase <=> b.email.downcase }
  end
end
