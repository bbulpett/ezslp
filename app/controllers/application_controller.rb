class ApplicationController < ActionController::Base
  before_filter :authenticate_user!
  protect_from_forgery

#custom method for devise, redirects routes to patients after login instead of root
  def after_sign_in_path_for(resource_or_scope)
    patients_path
  end

#custom method for devise, redirects routes to login after logout instead of root
  def after_sign_out_path_for(resource_or_scope)
    login_path
  end

end
