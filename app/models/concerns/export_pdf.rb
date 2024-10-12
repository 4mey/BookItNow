# frozen_string_literal: true

# module ExportPdf
module ExportPdf
  extend ActiveSupport::Concern

  # module ClassMethods
  module ClassMethods
    def to_pdf
      require 'prawn'
      require 'prawn/table'

      options = { position: :center, column_widths: [40, 100, 100, 100, 100, 80, 80], width: 600 }

      header = %w[ID Title StartDate EndDate Description Location Category]
      data = all.map { |event| [event.id, event.title, event.start_date.to_s, event.end_date.to_s, event.description, event.location, event.category] }
      Prawn::Document.new do
        text 'All Events', align: :center, size: 18, style: :bold
        table([header, *data], header: true, **options)
      end.render
    end
  end
end
