# frozen_string_literal: true

require 'sinatra'
if development?
  require 'sinatra/reloader'
  also_reload File.join(__dir__, 'lib', '*.rb')
end

require_relative 'lib/container'
require_relative 'lib/matcher1'
require_relative 'lib/matcher2'
require_relative 'lib/matcher3'
require_relative 'lib/matcher4'

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

get %r{/mine_data/([12])/([^/]+?)/} do |operation, pub_file|
  full_name = File.join(public_dir, 'data', pub_file)
  halt 404, 'Файл не найден' unless File.exist?(full_name)

  if operation == '1'
    cont = Container.new(full_name)
    m1 = Matcher1.new
    m2 = Matcher2.new
    m3 = Matcher3.new
    m4 = Matcher4.new
    a1 = m1.process(cont.text)
    a2 = m2.process(cont.text)
    a3 = m3.process(cont.text)
    a4 = m4.process(cont.text)

    # 1 is the lowest priority
    all = (a1 + a2 + a3 + a4).sort_by { |annotation| annotation[:priority] }

    result = cont.create_annotated_ext(all)
  end

  erb(
    :pub_file_and_mined_data, {
      layout: :_layout,
      locals: {
        file_url: "/show_data_file/#{pub_file}/",
        value: result
      }
    }
  )
end
