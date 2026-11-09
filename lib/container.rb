# frozen_string_literal: true

require 'cgi/escape'

# read-write
class Container
  attr_accessor :full_name, :text

  def initialize(full_name)
    @full_name = full_name
    @text = File.read(@full_name)
  end

  def create_annotated(annotations)
    left = 0
    result = ''
    annotations.each do |a|
      piece_before = @text[left...a[:begin]]
      piece_target = @text[a[:begin]...a[:end]]
      left = a[:end]

      # escape
      piece_before = CGI.escapeHTML(piece_before)
      piece_target = "<span class='#{a[:css]}'>#{CGI.escapeHTML(piece_target)}</span>"
      # indents
      piece_before = piece_before.gsub(/^[ \t]+/) do
        '&nbsp;' * ::Regexp.last_match(0).length
      end
      piece_target = piece_target.gsub(/^[ \t]+/) do
        '&nbsp;' * ::Regexp.last_match(0).length
      end
      # eol
      piece_before = piece_before.gsub(/\n/, '<br>')
      piece_target = piece_target.gsub(/\n/, '<br>')

      result += piece_before
      result += piece_target
    end

    # escape
    tail = CGI.escapeHTML(@text[left...@text.length])
    # indents
    tail = tail.gsub(/^[ \t]+/) do
      '&nbsp;' * ::Regexp.last_match(0).length
    end
    # eol
    tail = tail.gsub(/\n/, '<br>')

    result += tail

    result
  end
end
