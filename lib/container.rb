# frozen_string_literal: true

require 'cgi/escape'

# read-write
class Container
  attr_accessor :full_name, :text

  def initialize(full_name)
    @full_name = full_name
    @text = File.read(@full_name)
  end

  # all annotations are already sorted by priority
  def create_annotated_ext(annotations)
    # the whole text is not painted yet
    colors = Array.new(@text.length, 'empty')
    annotations.each do |a|
      (a[:begin]...a[:end]).each do |idx|
        colors[idx] = a[:css]
      end
    end

    # span-s for everything (even for not painted)
    result = '<span style="">'
    current_class = 'empty'

    colors.each_index do |idx|
      # add open tag to the result
      if colors[idx] != current_class
        # close old
        result += '</span>'
        # open new
        result += "<span style='#{colors[idx]}'>"

        current_class = colors[idx]
      end

      # add letter
      result += CGI.escapeHTML(@text[idx])
    end
    result += '</span>'

    # indents
    result = result.gsub(/^[ \t]+/) do
      '&nbsp;' * ::Regexp.last_match(0).length
    end
    # eol
    result.gsub(/\n/, '<br>')
  end
end
