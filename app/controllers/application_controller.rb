class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def authorize_user
    unless current_user && current_user.admin
      flash[:alert] = "Access denied."
      redirect_to action: 'index'
    end
  end

end
