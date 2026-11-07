# frozen_string_literal: true

require_relative './processor'

# leave capital words only
class Processor2 < Processor
  def process
    result = ''
    File.foreach(@full_name) do |line|
      updated_line = line.gsub(/[^A-Z]/, '-')
      # escape not my HTML markup if we have it
      result += escape(updated_line)
      # but do not touch my HTML markup
      result += '<br>'
    end
    result
  end
end
