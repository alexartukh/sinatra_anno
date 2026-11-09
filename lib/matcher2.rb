# frozen_string_literal: true

require_relative 'matcher'

# import something
class Matcher2 < Matcher
  def initialize
    super()
    self.re = /^import.+$/
    self.css = 'marked2'
    self.priority = 2
  end
end
