# frozen_string_literal: true

# Migration class to create rsvp
class CreateRsvps < ActiveRecord::Migration[7.1]
  def change
    create_table :rsvps do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.string :rsvp_status

      t.timestamps
    end
  end
end
