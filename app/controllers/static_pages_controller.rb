class StaticPagesController < ApplicationController
	skip_before_filter  :authenticate_user!, :except => [:home, :help]
	layout 'static_pages'
  #set_tab :home

	#adding this some home gets the same layout as the application
	def home
		render :layout => 'application'
	end

	def help
		render :layout => 'application'
	end


  def invalid_route
    flash[:notice] = 'You have requested an invalid page.'
    redirect_to :action => 'home'
  end

  def register
    @user = User.new
    @user.build_organization
  end

  def screencasts
  end

	#see html in app/view/static_pages/about.html.erb
	#																	/contact...
	#																	/pricing...
	#see app/view/users/new => /register
	#see app/view/user_session/new => /login
end
