# frozen_string_literal: true

# Migration class to add role_type and status column
class AddNewColumns < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :status, :integer
    add_column :users, :role_type, :integer
  end
end
