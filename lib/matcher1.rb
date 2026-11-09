# frozen_string_literal: true

require 'English'

# useState
class Matcher1
  def process(text)
    result = []
    text.scan(/const \[.+?useState\(.+?\);?/) do |matched_text|
      match = $LAST_MATCH_INFO
      tmp = {
        text: matched_text,
        begin: match.begin(0),
        end: match.end(0),
        css: 'marked1',
        priority: 1
      }
      result.push(tmp)
    end
    result
  end
end
