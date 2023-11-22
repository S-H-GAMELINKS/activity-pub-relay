# frozen_string_literal: true

# :nodoc:
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
