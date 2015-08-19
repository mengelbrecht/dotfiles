require 'pathname'
require 'tempfile'

task :default => :update

task :setup => ["setup:setup"]

verbose(false)

$excludes = ["LICENSE", "README.md", "Rakefile", "osx-setup", "Xcode", "Terminal"]
$root = File.expand_path(File.dirname(__FILE__))
$home = File.expand_path("~")
$osx = RUBY_PLATFORM.include? "darwin"
$linux = RUBY_PLATFORM.include? "linux"
$windows = RUBY_PLATFORM =~ /cygwin|mswin|mingw/

namespace :setup do
  task :setup => [:osx, :homebrew, :local, :dotfiles]

  task :osx do
    next unless $osx
    sh File.join($root, "osx-setup")
  end

  task :homebrew do
    next if $windows

    `which brew &> /dev/null`
    unless $?.success?
      info("installing homebrew")
      sh 'ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"' if $osx
      sh 'ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/linuxbrew/go/install)"' if $linux
    end

    installed_packages = `brew list`
    packages = ['coreutils', 'git']
    packages.each {|name|
      sh "brew install #{name}" unless installed_packages.include?(name)
    }
  end

  task :local do
    localFiles = ["gitconfig.local", "zshrc.local"]
    localFiles.each {|f|
      path = File.join($root, f)
      unless File.exists?(path)
        info("created empty local file '#{path}'")
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
end

task :update do
  sh 'git pull'
  sh 'git submodule update --init --recursive'
end

#### Helper Classes and Functions

class String
  def colorize(colorCode) "\e[#{colorCode}m#{self}\e[0m" end

  def red() colorize(31) end
  def green() colorize(32) end
  def yellow() colorize(33) end
  def blue() colorize(34) end
end

def realpath(path)
  return Pathname.new(path).realpath() if $osx
  return `readlink -f "#{path}"`
end

def readlink(path)
  return `readlink "#{path}"`
end

def is_symlink(path)
  return readlink(path) != ""
end

def do_symlink(source, dest)
  `ln -s "#{source}" "#{dest}"`
end

def symlink_path(source, dest)
  if not File.exists?(dest) and is_symlink(dest)
    info("deleting broken symlink '#{dest}' to '#{readlink(dest)}'")
    File.delete(dest)
  end
  if File.exists?(dest)
    return if realpath(source) == realpath(dest)
    backup = "#{dest}.#{Time.now.strftime("%Y%m%d%H%M%S")}"
    warning("target '#{dest}' already exists, backing up to '#{backup}'")
    File.rename(dest, backup)
  end
  do_symlink(source, dest)
  info("symlinked '#{source}' to '#{dest}'")
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
