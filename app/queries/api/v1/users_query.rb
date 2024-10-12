# frozen_string_literal: true

module Api
  module V1
    # Class to handle user queries for API in the database
    class UsersQuery < UsersController
      def call(params)
        users = User.all
        users = users.filtered_by_first_name(params[:first_name])
        users = users.filtered_by_last_name(params[:last_name])
        users.filtered_by_email(params[:email])
      end
    end
  end
end
