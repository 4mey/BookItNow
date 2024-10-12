# frozen_string_literal: true

# Controller Class for Avatar
module Attendees
  # Controller class for attendee avatar
  class AvatarsController < Attendees::ApplicationController
    before_action :check_empty_input, only: :update

    def new; end

    def update
      if current_attendee.update(avatar: params[:attendee][:avatar])
        flash[:notice] = 'Update Successful'
      else
        flash[:warnings] = current_attendee.errors.full_messages
      end
      redirect_to new_attendees_avatar_path
    end

    def destroy
      current_attendee.avatar.purge
      flash[:notice] = 'Avatar Deleted'
      redirect_to new_attendees_avatar_path
    end

    def check_empty_input
      return unless params[:attendee].blank?

      redirect_to new_attendees_avatar_path
      flash[:warnings] = 'Please Attach a file'
    end
  end
end
