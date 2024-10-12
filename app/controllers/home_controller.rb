# frozen_string_literal: true

# Class for home controller
class HomeController < ApplicationController
  before_action :authenticate_event_manager!, only: [:dashboard]
  def homepage; end
  def dashboard; end
end
