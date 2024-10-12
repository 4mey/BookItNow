# frozen_string_literal: true

module TestingHelpers
  def json_parse
    JSON.parse(response.body)
  end

  def check_list
    @events[0..9].each do |event|
      expect(page).to have_content(event.id)
    end
  end

  def filter_by_category(category)
    @events.where(category:)
  end

  def filter_by_status(status)
    @events.where(status:)
  end
end
