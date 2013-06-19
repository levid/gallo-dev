class ApplicationController < ActionController::Base
  include ControllerAuthentication
  protect_from_forgery

  after_filter  :set_csrf_cookie_for_ng

  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  SAVE_TO_DB = false

  private

  # AngularJS automatically sends CSRF token as a header called X-XSRF
  # this makes sure rails gets it
  def verified_request?
    super || form_authenticity_token == request.headers['X_XSRF_TOKEN']
  end
end
