task :default => ["all"]
task :all => [:homebrew, :local, :dotfiles]

task :local do
  root = File.expand_path(File.dirname(__FILE__))
  localFiles = ["Brewfile.local", "gitconfig.local", "slate.js.local", "vimrc.local", "zshrc.local"]
  localFiles.each {|f|
    path = File.join(root, f)
    unless File.exists?(path)
      info("created empty local file #{path}")
      FileUtils.touch(path)
    end
  }
end

task :homebrew do
  if which("brew").empty?
    info("installing homebrew")
    `ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"`
  end

  unless `brew tap`.split().include?('phinze/cask')
    info("installing homebrew cask support")
    `brew tap phinze/homebrew-cask`
  end
end

task :dotfiles do
  excludes = ["LICENSE", "README.md", "setup.py", "setup.rb", "Rakefile"]
  root = File.expand_path(File.dirname(__FILE__))

  Dir.foreach(root) {|f|
    unless f.start_with?(".") or excludes.include?(f)
      symlink_path(File.join(root, f), File.join(Dir.home, ".#{File.basename(f)}"))
    end
  }

  Dir.foreach(File.join(root, "zprezto", "runcoms")) {|f|
    if f.start_with?("z")
      symlink_path(File.join(Dir.home, ".zprezto", "runcoms", f), File.join(Dir.home, ".#{f}"))
    end
  }
end

#### Helper Classes and Functions

class String
  def colorize(colorCode)
    "\e[#{colorCode}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def blue
    colorize(34)
  end
end

def which(binary)
  paths = ENV["PATH"].split(File::PATH_SEPARATOR)
  paths.map {|path| File.join(path, binary)}.find {|p| File.exists?(p) and File.executable?(p)}
end

def symlink_path(source, dest)
  if File.exists?(dest) and File.symlink?(dest)
    if File.realpath(source) == File.realpath(dest)
      return
    else
      warning("deleting unknown symlink #{dest}")
      File.delete(dest)
    end
  end
  if File.exists?(dest)
    error("target #{dest} already exists")
  else
    File.symlink(source, dest)
    info("symlinked #{source} to #{dest}")
  end
end

def info(msg, *args)
  puts "#{"info".green}: #{msg % args}"
end

def warning(msg, *args)
  puts "#{"warning".yellow}: #{msg % args}"
end

def error(msg, *args)
  puts "#{"error".red}: #{msg % args}"
end

