# frozen_string_literal: true

require 'sinatra'
if development?
  require 'sinatra/reloader'
  also_reload File.join(__dir__, 'lib', '*.rb')
end
require 'yaml'

require_relative 'lib/container'
require_relative 'lib/matcher'

set :views, File.join(__dir__, 'templates')
public_dir = File.join(__dir__, 'public')

# ------------------------------------------------------------------

get '/' do
  public_data_files = Dir.children(File.join(public_dir, 'data'))
  public_data_files.sort! { |a, b| a <=> b }
  public_file_extensions = []
  public_data_files.each do |fn|
    ext = fn =~ /\.([^.]+)$/ ? Regexp.last_match(1) : ''
    public_file_extensions.push(ext)
  end

  erb(
    :all_public_data, {
      layout: :_layout,
      locals: {
        public_files: public_data_files,
        public_file_extensions: public_file_extensions
      }
    }
  )
end

# ------------------------------------------------------------------

get %r{/show_data_file/([^/]+?)/} do |pub_file|
  full_name = File.join(public_dir, 'data', pub_file)
  halt 404, 'Файл не найден' unless File.exist?(full_name)

  send_file(
    full_name, {
      type: 'text/plain',
      disposition: 'inline'
    }
  )
end

# ------------------------------------------------------------------

get %r{/mine_data/([123])/([^/]+?)/} do |operation, pub_file|
  full_name = File.join(public_dir, 'data', pub_file)
  halt 404, 'Файл не найден' unless File.exist?(full_name)

  if operation == '1'
    draw_js_lines = ''
    container = Container.new(full_name)
    yaml_full_name = File.join(__dir__, 'matchers.yml')

    annotations = [] # array of arrays of hashes
    YAML.load_file(yaml_full_name).each do |cfg|
      m = Matcher.new(cfg)
      aoh = m.process(container)
      annotations.push(aoh)

      if m.postprocessing == 'SEQUENCE'
        last_point = nil
        aoh.each do |a|
          if last_point.nil?
            last_point = [a[:begin_line], a[:begin_col]]
            next
          end

          current_point = [a[:begin_line], a[:begin_col]]
          draw_js_lines += format(
            "drawSegment(%d, %d, %d, %d);\n",
            last_point[0], last_point[1], current_point[0], current_point[1]
          )

          last_point = current_point
        end
      end

      if m.postprocessing == 'FOO'
      end

      if m.postprocessing == 'BAR'
      end
    end

    # make a single sorterd list from all annotations
    annotations_sorted = []
    annotations.each do |a|
      annotations_sorted += a
    end
    # we need a sorted list to generate a result
    # when an annotation with a higher priority will override
    # an annotation with a lower priority
    annotations_sorted = annotations_sorted.sort_by { |a| a[:priority] }
    result = container.create_annotated_ext(annotations_sorted)
  end

  erb(
    :pub_file_and_mined_data, {
      layout: :_layout,
      locals: {
        file_url: "/show_data_file/#{pub_file}/",
        value: result,
        draw_js_lines: draw_js_lines
      }
    }
  )
end
