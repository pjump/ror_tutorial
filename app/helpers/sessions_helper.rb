module SessionsHelper

  def sign_in(user)
    remember_token = User.new_remember_token #create new session token
    cookies.permanent[:remember_token] = remember_token #remember it in a cookie
    user.update_attribute(:remember_token, User.hash(remember_token)) #save it hashed to the db
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    if signed_in?
      current_user.update_attribute(:remember_token,
                                    User.hash(User.new_remember_token))
      cookies.delete(:remember_token)
      self.current_user = nil
    end
  end

  attr_writer :current_user
  #def current_user=(user)
    #@current_user = user
  #end

  def current_user
    @current_user ||=  #assigned by sign_in in a cookie
      User.find_by(remember_token: 
                   User.hash(cookies[:remember_token]))
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end

end
