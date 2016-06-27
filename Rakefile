# Rake tasks to parse haml layouts, includes and index files for jekyll
# Assumes that the haml files are in (_layouts|_includes)/_haml

namespace :haml do
  require 'haml'

  def convert file, destination
    base_name = File.basename(file, '.haml') + '.html'
    convert_full file, File.join(destination, base_name)
  end

  def convert_full from, to
    html = Haml::Engine.new(File.read(from)).render
    File.open(to, 'w') { |f| f.write html }
  end

  desc 'Parse haml layout files'
  task :layouts do
    Dir.glob('_layouts/_haml/*.haml') do |path|
      convert path, '_layouts'
    end

    puts 'Parsed haml layout files'
  end

  desc 'Parse haml include files'
  task :includes do
    Dir.glob('_includes/_haml/*.haml') do |path|
      convert path, '_includes'
    end

    puts 'Parsed haml include files'
  end

  desc 'Parse haml index files'
  task :indexes do
    convert './index.haml', File.dirname('./index.haml')

    puts 'Parsed haml index files'
  end
end

desc 'Parse all haml items'
task haml: ['haml:layouts', 'haml:includes', 'haml:indexes']

desc 'Build all haml and sass files for deployment'
task build: [:haml]
