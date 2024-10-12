# frozen_string_literal: true

# Class to run migration to create article schema
class CreateArticles < ActiveRecord::Migration[7.1]
  def change
    create_table :articles do |t|
      t.string :article_name
      t.string :author
      t.string :subject

      t.timestamps
    end
  end
end
