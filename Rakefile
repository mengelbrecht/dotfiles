require 'pathname'

task :default => :update

task :setup => ["setup:setup"]

verbose(false)

$excludes = ["LICENSE", "README.md", "Rakefile", "osx.bash", "Xcode", "Terminal", "TextMate"]
$root = File.expand_path(File.dirname(__FILE__))
$home = File.expand_path("~")
$osx = RUBY_PLATFORM.include? "darwin"
$linux = RUBY_PLATFORM.include? "linux"

namespace :setup do
  task :setup => [:osx, :homebrew, :local, :dotfiles, :luarocks]

  task :osx do
    unless $osx
      next
    end

    sh File.join($root, "osx.bash")
  end

  task :homebrew do
    unless $osx
      next
    end

    if `which brew`.empty?
      info("installing homebrew")
      sh 'ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"'
    end

    installed_packages = `brew list`
    packages = ['git', 'lua', 'luarocks']
    packages.each {|name|
      if installed_packages.include?(name)
        info("skipping installation of package #{name}, already installed")
      else
        sh "brew install #{package}"
      end
    }
  end

  task :local do
    localFiles = ["gitconfig.local", "zshrc.local"]
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
        symlink_path(File.join($root, f), File.join($home, ".#{File.basename(f)}"))
      end
    }

    Dir.foreach(File.join($root, "zprezto", "runcoms")) {|f|
      if f.start_with?("z")
        symlink_path(File.join($home, ".zprezto", "runcoms", f), File.join($home, ".#{f}"))
      end
    }
  end

  task :luarocks do
    unless $osx
      next
    end

    installed_rocks = `luarocks list`
    rocks = [
      'moonscript',
    ]
    rocks.each {|name|
      if installed_rocks.include?(name)
        info("skipping installation of rock #{name}, already installed")
      else
        sh "luarocks --tree=hammerspoon install #{name}"
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

def symlink_path(source, dest)
  if not File.exists?(dest) and File.symlink?(dest)
    info("deleting broken symlink #{dest} to #{File.readlink(dest)}")
    File.delete(dest)
  end
  if File.exists?(dest)
    if File.symlink?(dest)
      if Pathname.new(source).realpath() == Pathname.new(dest).realpath()
        return
      else
        warning("deleting unknown symlink #{dest} to #{Pathname.new(dest).realpath()}")
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

def info(msg, *args)
  puts "#{"info".green}: #{msg % args}"
end

def warning(msg, *args)
  puts "#{"warning".yellow}: #{msg % args}"
end

def error(msg, *args)
  puts "#{"error".red}: #{msg % args}"
end
