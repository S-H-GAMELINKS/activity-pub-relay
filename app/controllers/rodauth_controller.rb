class RodauthController < ApplicationController
  # Used by Rodauth for rendering views, CSRF protection, running any
  # registered action callbacks and rescue handlers, instrumentation etc.

  # Controller callbacks and rescue handlers will run around Rodauth endpoints.
  # before_action :verify_captcha, only: :login, if: -> { request.post? }
  # rescue_from("SomeError") { |exception| ... }

  # Layout can be changed for all Rodauth pages or only certain pages.
  # layout "authentication"
  layout -> do
    case rodauth.current_route
    when :otp
      "application"
    else
      "application"
    end
  end
end
