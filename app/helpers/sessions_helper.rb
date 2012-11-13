module SessionsHelper

  def sign_in(user)
    Rails.logger.info("......sign_in CALLED.....................")
    cookies.permanent[:remember_token] = user.remember_token
    
    Rails.logger.info("......user.remember_token.....................")
    Rails.logger.info(user.remember_token)
    
    self.current_user = user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    Rails.logger.info("......current_user CALLED.....................")
    Rails.logger.info("......user.remember_token.....................")
    Rails.logger.info(cookies[:remember_token])

    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end
end
