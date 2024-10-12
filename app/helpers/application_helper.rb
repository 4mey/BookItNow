# frozen_string_literal: true

# Main helper module for the applications
module ApplicationHelper
  def sort_headers(column, column_header)
    sort_link @q, column, column_header
  end
end
