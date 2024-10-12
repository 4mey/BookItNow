# frozen_string_literal: true

# Main Class to handle mailers
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
