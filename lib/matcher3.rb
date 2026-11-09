# frozen_string_literal: true

require_relative 'matcher'

# useState pair
class Matcher3 < Matcher
  def initialize
    super()
    self.re = /\[\s*\w+\s*,\s*set\w+\s*\]/
    self.css = 'marked3'
    self.priority = 3
  end
end
