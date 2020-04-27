#encoding:utf-8

def makeSymbolicLink(source, target)
  unless File.exists? target
    puts "Make symbolic link #{source} -> #{target}"
    system("ln -s #{source} #{target}")
  end
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

    ZPLUG_HOME="#{ENV["HOME"]}/.zsh/zplug"
    puts "Install Zplug"
    system("git clone https://github.com/zplug/zplug #{ZPLUG_HOME}")
  end,
  :myscripts => Proc.new do
    MYSCRIPTS_HOST_DIR = "#{Dir.pwd}/myscripts/.myscripts"
    MYSCRIPTS_TARGET_DIR = "#{ENV["HOME"]}/.myscripts"

    unless File.exists? MYSCRIPTS_HOST_DIR
      system("git clone https://github.com/alphaKAI/myscripts --recursive #{MYSCRIPTS_HOST_DIR}")
    end

    unless File.exists? MYSCRIPTS_TARGET_DIR
      makeSymbolicLink(MYSCRIPTS_HOST_DIR, MYSCRIPTS_TARGET_DIR)
    end

    system("cd #{MYSCRIPTS_TARGET_DIR}; rdmd build")
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
