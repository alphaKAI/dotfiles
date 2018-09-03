#encoding:utf-8

def makeSymbolicLink(source, target)
  puts "Make symbolic link #{source} -> #{target}"
  system("ln -s #{source} #{target}")
end

Components = [
  :vim,
  :zsh,
  :myscripts
]

ALL = Components

Configurations = {
  :vim => Proc.new do
    unless File.exist?("#{ENV["HOME"]}/.vim")
      Dir.mkdir("#{Dir.pwd}/vim/.vim")
      makeSymbolicLink("#{Dir.pwd}/vim/.vim", "#{ENV["HOME"]}/.vim")
    end

    unless File.exist?("#{ENV["HOME"]}/.vim/bundle")
      puts "[mkdir] path : #{ENV["HOME"]}/.vim/bundle mode : 755"
      Dir.mkdir("#{ENV["HOME"]}/.vim/bundle", 0755)
      puts "--------------------------------------"
      puts " * [git clone] -> NeoBundle"
      system("git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim")
      puts "--------------------------------------"
    end

    makeSymbolicLink("#{Dir.pwd}/vim/.vimrc", "#{ENV["HOME"]}/.vimrc")
    makeSymbolicLink("#{Dir.pwd}/vim/.gvimrc", "#{ENV["HOME"]}/.gvimrc")
    makeSymbolicLink("#{Dir.pwd}/vim/.vim_neobundle", "#{ENV["HOME"]}/.vim_neobundle")
  end,
  :zsh => Proc.new do
    makeSymbolicLink("#{Dir.pwd}/zsh/.zsh", "#{ENV["HOME"]}/.zsh")
    makeSymbolicLink("#{Dir.pwd}/zsh/.zshrc", "#{ENV["HOME"]}/.zshrc")
  end,
  :myscripts => Proc.new do
    system("git submodule update --init --recursive")

    DCommands = {
      "amv" => "local",
      "cxz" => "local",
      "xxz" => "local",
      "twitnotify"   => "https://github.com/alphaKAI/twitnotify",
      "streamFilter" => "https://github.com/alphaKAI/streamFilter",
      "doco"         => "https://github.com/alphaKAI/doco",
      "dww"          => "https://github.com/alphaKAI/dww"
    }

    unless File.exists? "#{ENV["HOME"]}/.myscripts"
      Dir.mkdir("#{ENV["HOME"]}/.myscripts")
    end
    unless File.exists? "#{Dir.pwd}/myscripts/.myscripts"
      makeSymbolicLink("#{Dir.pwd}/myscripts/.myscripts", "#{ENV["HOME"]}/.myscripts")
    end
    oldDir = Dir.pwd
    Dir.chdir("#{ENV["HOME"]}/.myscripts")
    system("git submodule update --init --recursive")

    DCommands.each do |key, value|
      puts "DCommand - #{key}"
      if File.exists? "#{ENV["HOME"]}/.myscripts/#{key}"
        _oldDir = Dir.pwd
        Dir.chdir(key)
        unless value == "local"
          system("git pull")
        end
        system("dub build")
        Dir.chdir(_oldDir)
      else
        unless value == "local"
          system("git clone #{value}")
          _oldDir = Dir.pwd
          Dir.chdir(key)
          system("dub build")
          Dir.chdir(_oldDir)
        else
          puts "[Error] local - #{key} is not exists!"
        end
      end
    end

    Dir.chdir(oldDir)
  end
}

targets = ARGV.map{|e| e.to_sym }

if targets.length == 0
  targets = ALL
end

targets.each do |target|
  puts "Configurating... - #{target}"
  Configurations[target].call
end
