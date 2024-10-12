# frozen_string_literal: true

module Attendees
  # Event Controller for Attendee
  class ApplicationController < ApplicationController
    before_action :authenticate_attendee!
  end
end
