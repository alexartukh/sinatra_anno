# frozen_string_literal: true

require 'English'

# import
class Matcher2
  def process(text)
    result = []
    text.scan(/^import.+$/) do |matched_text|
      match = $LAST_MATCH_INFO
      tmp = {
        text: matched_text,
        begin: match.begin(0),
        end: match.end(0),
        css: 'marked2',
        priority: 2
      }
      result.push(tmp)
    end
    result
  end
end
