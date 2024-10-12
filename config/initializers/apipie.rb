# frozen_string_literal: true

Apipie.configure do |config|
  config.app_name                = 'NewBlog'
  config.api_base_url            = nil
  config.doc_base_url            = '/apipie'
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
  config.validate = false
end
