# frozen_string_literal: true

module Api
  module V1
    # Controller class for API user controller
    class UsersController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :find_user, only: %i[show update destroy]
      before_action :authenticate_admin!

      def_param_group :user do
        property :id, String, desc: 'ID of the user'
        property :first_name, String, desc: 'First Name of the user'
        property :last_name, String, desc: 'Last Name of the user'
        property :email, String, desc: 'Mail ID of the User'
        property :date_of_birth, Date, desc: 'Date of Birth of the user'
        property :age, Integer, desc: 'Age of the user'
        property :created_at, String, desc: 'When the user was created'
      end

      api :GET, '/api/v1/users', 'Get all user records'
      param :first_name, String, desc: 'Filter param for First Name'
      param :last_name, String, desc: 'Filter param Last Name'
      param :email, String, desc: 'Filter param for Email'
      returns array_of: :user, code: 200, desc: 'List of Users'
      def index
        users = UsersQuery.new.call(params)
        render json: users
      end

      api :POST, '/api/v1/users', 'Create a user'
      param :user, Hash, desc: 'User info', required: true do
        param :first_name, String, desc: 'First Name of the user', required: true
        param :last_name, String, desc: 'Last Name of the user', required: true
        param :email, String, desc: 'Mail ID of the User', required: true
        param :age, Integer, desc: 'Age of the user', required: true
        param :date_of_birth, Date, desc: 'User date of birth', required: true
        param :password, String, desc: 'User password', required: true
      end
      returns param_group: :user, code: 201, desc: 'Created user'
      def create
        outcome = CreateUser.run(params.fetch(:user, {}))
        if outcome.valid?
          render json: outcome.result, status: 201
        else
          render json: outcome.errors.messages, status: 422
        end
      end

      api :GET, '/api/v1/users/:id', 'Path to show API with ID'
      param :id, :number, desc: 'id of the requested user', required: true
      returns param_group: :user, code: 200, desc: 'Requested User'
      def show
        render json: @user, status: 200
      end

      api :PUT, '/api/v1/users/:id', 'Path to Update API with ID'
      param :id, :number, desc: 'Id of user to be updated', required: true
      param :user, Hash, desc: 'User info' do
        param :first_name, String, desc: 'First Name of the user'
        param :last_name, String, desc: 'Last Name of the user'
        param :email, String, desc: 'Mail ID of the User'
        param :age, Integer, desc: 'Age of the user'
        param :date_of_birth, Date, desc: 'User date of birth'
        param :password, String, desc: 'User password'
      end
      returns param_group: :user, code: 200, desc: 'Updated User'
      def update
        inputs = params.fetch(:user, {}).merge(user: @user)
        outcome = UpdateUser.run(inputs)

        if outcome.valid?
          render json: outcome.result, status: 200
        else
          render json: outcome.errors.messages, status: :unprocessable_entity
        end
      end

      api :DELETE, '/api/v1/users/:id', 'Path to delete API with ID'
      param :id, :number, desc: 'id of user to be deleted', required: true
      def destroy
        @user.destroy
        render json: { message: 'User deleted' }, status: 200
      end

      def find_user
        @user = User.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        render json: { error: e }, status: 404
      end
    end
  end
end
