#Modified by gato_omega it so that only html.erb files and not js.erb are changed
require 'haml'
require 'hpricot'
require 'ruby_parser'

class ToHaml
  def initialize(path)
    @path = path
    @backup_strategy = :delete
    @use_git = true
  end
  
  def convert!
    puts "Applying backup strategy> #{@backup_strategy.to_s.capitalize}"
    number_of_files = 0
    Dir["#{@path}/**/*.html.erb"].each do |file|
      puts "converting #{file}..."
      `html2haml -rx #{file} #{file.gsub(/\.html\.erb$/, '.html.haml')}`
      if @backup_strategy.eql? :none
        #Leave original there
      elsif @backup_strategy.eql? :move
        `#{apply_git}mv #{file} #{file}.moved`
      elsif @backup_strategy.eql? :rename
        `#{apply_git}mv #{file} #{file}.txt`
      elsif @backup_strategy.eql? :delete
        `#{apply_git}rm #{file}`
      end
      number_of_files += 1
    end

    if @use_git
      `git status`
    end
    puts "Done converting #{number_of_files} files!"
  end

  def apply_git
    if @use_git
      'git '
    end
  end
end

path = File.join(File.dirname(__FILE__), 'app', 'views')
ToHaml.new(path).convert!
