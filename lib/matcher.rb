# frozen_string_literal: true

require 'English'

# base class for all matchers
class Matcher
  attr_accessor :name, :regexp, :css, :priority, :id

  def initialize(name, regexp, css, priority)
    @id = 1 # this value will be assigned next time
    @name = name
    @regexp = Regexp.new(regexp)
    @css = css
    @priority = priority
  end

  def process(text)
    result = []
    text.scan(@regexp) do |matched_text|
      match = $LAST_MATCH_INFO
      tmp = {
        id: @id,
        text: matched_text,
        begin: match.begin(0),
        end: match.end(0),
        css: @css,
        priority: @priority
      }
      @id += 1
      result.push(tmp)
    end
    result
  end
end
