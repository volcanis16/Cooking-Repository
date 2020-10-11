class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Excepting the sign in page, every page requires the user to be signed in.
  before_action :authenticate_user!

  ##Break into array, remove whitespace, remove empty entries.
  def split_and_strip(input, split_point)
    input = input.split(split_point).map {|i| i.strip }
    input.map { |i| i.blank? ? next : i }.compact
  end

  protected

  # Devise param config
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:admin])
    devise_parameter_sanitizer.permit(:update, keys: [:account_id])
  end

  def check_admin
    if user_signed_in? && !current_user.admin
      flash.notice = "You don't have access to that page."
      redirect_back fallback_location: root_path
    end
  end
end
