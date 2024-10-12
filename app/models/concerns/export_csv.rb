# frozen_string_literal: true

# module ExportCSV
module ExportCsv
  extend ActiveSupport::Concern

  # module ClassMethods
  module ClassMethods
    def to_csv
      require 'csv'
      options = { col_sep: ';', encoding: 'utf-8' }
      headers = %i[ID Title Description StartDate EndDate Location Category]

      CSV.generate(headers: true, **options) do |csv|
        csv << headers

        all.each do |event|
          csv << [event.id, event.title, event.description, event.start_date, event.end_date, event.location, event.category]
        end
      end
    end
  end
end
