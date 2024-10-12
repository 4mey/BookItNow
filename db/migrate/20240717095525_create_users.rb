# frozen_string_literal: true

# Class to run migration to create new schema
class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.integer :age
      t.date :date_of_birth
      t.string :password

      t.timestamps
    end
  end
end
