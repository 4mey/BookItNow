# frozen_string_literal: true

# Class to remove extra password column from the table
class DeletePasswordColumn < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :password
  end
end
