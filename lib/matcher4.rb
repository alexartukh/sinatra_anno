# frozen_string_literal: true

require_relative 'matcher'

# setFoo
class Matcher4 < Matcher
  def initialize
    super()
    self.re = /\bset[A-Z]\w*\b/
    self.css = 'marked4'
    self.priority = 4
  end
end
