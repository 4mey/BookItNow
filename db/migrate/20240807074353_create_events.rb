# frozen_string_literal: true

# Migration class to add events table
class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.datetime :start_date
      t.datetime :end_date
      t.string :location
      t.string :status
      t.text :note
      t.integer :attendees_count
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
