class TraderMailer < ApplicationMailer
  default from: 'arcferrer5@gmail.com'

  def signup_notification(trader)
    @trader = trader
    mail to: @trader.email, subject: 'Welcome to Our App - Signup Confirmation'
  end

  def admin_signup_notification(trader)
    @trader = trader
    mail to: 'arcferrer5@gmail.com', subject: 'Welcome to Our App - Signup Confirmation'
  end

  def approval_notification(trader)
    @trader = trader
    mail to: @trader.email, subject: 'Your Trader Account has been Approved'
  end

  def account_creation_notification(trader)
    @trader = trader
    mail to: @trader.email, subject: 'Admin Created You an Trader Account'
  end

  def account_hold_notification(trader)
    @trader = trader
    mail to: @trader.email, subject: 'Hold Up - Temporary Suspension'
  end
end
