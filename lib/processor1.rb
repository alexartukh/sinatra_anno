# frozen_string_literal: true

require_relative './processor'

# REACT - useState
class Processor1 < Processor
  def process
    result = ''
    File.foreach(@full_name) do |line|
      updated_line = prepare_line(line)

      # useful work - highlight text
      updated_line = updated_line.sub(/const \[.+?useState\(.+?\);?/) do |m|
        "<span class='marked1'>#{m}</span>"
      end

      result += updated_line
      result += '<br>'
    end
    result
  end
end
