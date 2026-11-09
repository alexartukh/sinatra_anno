# frozen_string_literal: true

require 'cgi'

# base class for all processors
class Processor
  attr_accessor :full_name

  def initialize(full_name)
    @full_name = full_name
  end

  def prepare_line(line)
    updated_line = CGI.escapeHTML(line)
    updated_line.gsub(/^\s+/) do
      '&nbsp;' * ::Regexp.last_match(0).length
    end
  end
end
