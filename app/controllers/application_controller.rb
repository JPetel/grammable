class ApplicationController < ActionController::Base

  def render_not_found(status=:not_found)
    render plain: "#{status.to_s.titleize} :(", status: status
  end

  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

end
