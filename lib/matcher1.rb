# frozen_string_literal: true

require_relative 'matcher'

# useFoo function
class Matcher1 < Matcher
  def initialize
    super()
    self.re = /\buse[A-Z]\w*\b/
    self.css = 'marked1'
    self.priority = 1
  end
end
