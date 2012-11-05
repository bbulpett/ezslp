class UserMailer < ActionMailer::Base
  default :from => "from@example.com"

  def welcome_email(user)
    @user = user
    mail(:to => user.email, :subject => "Welcome to EzSLP and VisitTracker")
  end

  def registration_email(user)
    @user = user
    mail(:to => 'info@ezslp.com', :subject => "EzSLP Registration Notification")
  end

end
