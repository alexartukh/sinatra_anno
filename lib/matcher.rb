# frozen_string_literal: true

require 'English'

# base class for all matchers
class Matcher
  attr_accessor :id, :name, :regexp, :css, :priority, :postprocessing, :mods, :group

  # def initialize(name, regexp, css, priority)
  def initialize(cfg)
    @id = 1 # this value will be assigned next time
    # YAML keys are strings, not symbols

    # mandatory params
    @name = cfg.fetch('name')
    @regexp = cfg.fetch('regexp')
    @css = cfg.fetch('css')
    @priority = cfg.fetch('priority')
    raise "#{cfg.inspect} - name is nil" if @name.nil?
    raise "#{cfg.inspect} - regexp is nil" if @regexp.nil?
    raise "#{cfg.inspect} - css is nil" if @css.nil?
    raise "#{cfg.inspect} - priority is nil" if @priority.nil?

    # params with default values
    @postprocessing = cfg.fetch('postprocessing', '')
    @mods = cfg.fetch('mods', '')
    @group = cfg.fetch('group', 0)
    @belong_to_list = cfg.fetch('belong_to_list', nil)

    # string -> Regexp
    @regexp = Regexp.new(@regexp)
  end

  def process(container, annotations_as_hash)
    text = container.text
    result = []
    text.scan(@regexp) do
      match = $LAST_MATCH_INFO

      # 'belong_to_list' feature
      unless @belong_to_list.nil?
        next unless annotations_as_hash[@belong_to_list]
        next unless annotations_as_hash[@belong_to_list].any? do |h|
          h[:text] == match[@group]
        end
      end

      first_index = match.begin(@group)
      last_index = match.end(@group)
      begin_line, begin_col = container.search_for_line_col(first_index)
      end_line, end_col = container.search_for_line_col(last_index)
      tmp = {
        id: @id,
        text: match[@group],
        begin: first_index,
        end: last_index,
        begin_line: begin_line,
        begin_col: begin_col,
        end_line: end_line,
        end_col: end_col,
        css: @css,
        priority: @priority
      }
      @id += 1
      result.push(tmp)
    end
    result
  end
end
