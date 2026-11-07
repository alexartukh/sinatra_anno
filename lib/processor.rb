# frozen_string_literal: true

require 'cgi'

# base class for all processors
class Processor
  attr_accessor :full_name

  def initialize(full_name)
    @full_name = full_name
  end

  def escape(text)
    CGI.escapeHTML(text)
  end
end
