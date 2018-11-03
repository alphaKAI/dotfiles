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
    system("git clone https://github.com/alphaKAI/myscripts --recursive ./myscripts/.myscripts")

    unless File.exists? "#{ENV["HOME"]}/.myscripts"
      Dir.mkdir("#{ENV["HOME"]}/.myscripts")
    end
    unless File.exists? "#{Dir.pwd}/myscripts/.myscripts"
      makeSymbolicLink("#{Dir.pwd}/myscripts/.myscripts", "#{ENV["HOME"]}/.myscripts")
    end

    oldDir = Dir.pwd
    Dir.chdir("#{ENV["HOME"]}/.myscripts")
    system("rdmd build")
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
