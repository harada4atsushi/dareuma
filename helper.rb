helpers do
  def admin?
    return false unless session[:twitter]
    session[:twitter][:uid] == settings.config["admin_uid"]
  end
end