# frozen_string_literal: true

require 'cgi/escape'

# read-write
class Container
  attr_accessor :full_name, :text, :line_starts

  def initialize(full_name)
    @full_name = full_name
    @text = File.read(@full_name)

    @line_starts = [0] # первая строка начинается с 0
    idx = 0
    while idx < @text.length
      if @text[idx] == "\n"
        @line_starts.push(idx + 1) # следующая строка начинается после \n
      end
      idx += 1
    end
  end

  def search_for_line_col(idx)
    next_line = @line_starts.bsearch_index { |start| start > idx }
    if next_line.nil?
      next_line = @line_starts.length   # idx в последней строке
    end
    line = next_line                    # номер с 1
    column = idx - @line_starts[next_line - 1] + 1
    [line, column]
  end

  # all annotations are already sorted by priority
  def create_annotated_ext(annotations)
    # the whole text is not painted yet
    colors = Array.new(@text.length, '')
    annotations.each do |a|
      (a[:begin]...a[:end]).each do |idx|
        colors[idx] = a[:css]
      end
    end

    # span-s for everything (even for not painted)
    result = '<span style="">'
    current_class = ''

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
