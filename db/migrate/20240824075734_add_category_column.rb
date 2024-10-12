# frozen_string_literal: true

# Migration Class to Category Column in Events
class AddCategoryColumn < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :category, :integer
  end
end
