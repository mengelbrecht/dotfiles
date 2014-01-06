task :default => :update

task :setup => ["setup:setup"]

verbose(false)

$excludes = ["LICENSE", "README.md", "Rakefile", "osx.bash", "init"]
$root = File.expand_path(File.dirname(__FILE__))
$osx = RUBY_PLATFORM.include? "darwin"

namespace :setup do
  task :setup => [:fonts, :osx, :homebrew, :local, :dotfiles]

  task :fonts do
    if $osx
      fontFolder = File.expand_path(File.join("~", "Library", "Fonts"))
    else
      fontFolder = File.expand_path(File.join("~", ".fonts"))
    end

    Dir[File.join($root, "init", "powerline-fonts", "AnonymousPro", "*.ttf")].each {|f|
      link_path(f, File.join(fontFolder, File.basename(f)))
    }

    Dir[File.join($root, "init", "powerline-fonts", "SourceCodePro", "*.otf")].each {|f|
      link_path(f, File.join(fontFolder, File.basename(f)))
    }
  end

  task :osx do
    if $osx
      sh File.join($root, "osx.bash")
    end
  end

  task :homebrew do
    if not which("brew")
      info("installing homebrew")
      sh 'ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"'
    end

    unless `brew tap`.split().include?('phinze/cask')
      info("installing homebrew cask support")
      sh 'brew tap phinze/homebrew-cask'
    end
  end

  task :local do
    localFiles = ["Brewfile.local", "gitconfig.local", "slate.js.local", "vimrc.local", "zshrc.local"]
    localFiles.each {|f|
      path = File.join($root, f)
      unless File.exists?(path)
        info("created empty local file #{path}")
        FileUtils.touch(path)
      end
    }
  end

  task :dotfiles do
    Dir.foreach($root) {|f|
      unless f.start_with?(".") or $excludes.include?(f)
        symlink_path(File.join($root, f), File.join(Dir.home, ".#{File.basename(f)}"))
      end
    }

    Dir.foreach(File.join($root, "zprezto", "runcoms")) {|f|
      if f.start_with?("z")
        symlink_path(File.join(Dir.home, ".zprezto", "runcoms", f), File.join(Dir.home, ".#{f}"))
      end
    }
  end
end

task :update do
  sh 'git pull'
  sh 'git submodule update --init --recursive'
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
  paths = ENV['PATH'].split(File::PATH_SEPARATOR)
  paths.map {|path| File.join(path, binary)}.find {|p| File.exists?(p) and File.executable?(p)}
end

def symlink_path(source, dest)
  if not File.exists?(dest) and File.symlink?(dest)
    info("deleting broken symlink #{dest} to #{File.readlink(dest)}")
    File.delete(dest)
  end
  if File.exists?(dest)
    if File.symlink?(dest)
      if File.realpath(source) == File.realpath(dest)
        return
      else
        warning("deleting unknown symlink #{dest} to #{File.realpath(dest)}")
        File.delete(dest)
      end
    else
      backup = "#{dest}.#{Time.now.strftime("%Y%m%d%H%M%S")}"
      warning("target #{dest} already exists, backing up to #{backup}")
      File.rename(dest, backup)
    end
  end
  File.symlink(source, dest)
  info("symlinked #{source} to #{dest}")
end

def link_path(source, dest)
  unless File.exists?(dest)
    File.link(source, dest)
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

