# frozen_string_literal: true

require 'English'

# base class for all matchers
class Matcher
  attr_accessor :re, :priority, :css

  def initialize; end

  def process(text)
    result = []
    text.scan(@re) do |matched_text|
      match = $LAST_MATCH_INFO
      tmp = {
        text: matched_text,
        begin: match.begin(0),
        end: match.end(0),
        css: @css,
        priority: @priority
      }
      result.push(tmp)
    end
    result
  end
end
