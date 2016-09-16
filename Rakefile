require 'pathname'
require 'tempfile'

task :default => :update

task :setup => ['setup:setup']

verbose(false)

$excludes = ['LICENSE', 'macOS-setup.sh', 'Rakefile', 'README.md', 'Terminal', 'Xcode']
$root = File.expand_path(File.dirname(__FILE__))
$home = File.expand_path("~")
$osx = RUBY_PLATFORM.include? 'darwin'
$linux = RUBY_PLATFORM.include? 'linux'
$windows = RUBY_PLATFORM =~ /cygwin|mswin|mingw/

$homebrewPath = if $osx then '/usr/local' else "#{$home}/.homebrew" end
$binPath = File.join($homebrewPath, "bin")
$homebrewPackages = ['pt', 'cmake', 'coreutils', 'git', 'ncdu', 'ninja']
$localFiles = ['gitconfig.local', 'vim/vimrc.local', "zshrc.local"]

namespace :setup do
  task :setup => [:osx, :homebrew, :shell_helper, :local, :dotfiles]

  task :osx do
    next unless $osx
    sh File.join($root, 'macOS-setup.sh')
  end

  task :homebrew do
    next if $windows

    brewBin = `which brew 2> /dev/null`.strip
    unless $?.success?
      if $osx then
        info("installing homebrew")
        sh 'ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"'
      elsif $linux
        unless File.exists?($homebrewPath)
          info("installing homebrew")
          sh "git clone https://github.com/Homebrew/linuxbrew.git #{$homebrewPath}"
        else
          error("brew is not part of PATH but homebrew folder exists")
          next
        end
      end
      brewBin = "#{$homebrewPath}/bin/brew"
    end

    installedPackages = `#{brewBin} list`.split()
    ($homebrewPackages - installedPackages).each {|name| sh "#{brewBin} install #{name}"}
  end

  task :shell_helper do
    next unless $osx

    if File.exists?("/Applications/Atom.app")
      symlink_path("/Applications/Atom.app/Contents/Resources/app/apm/node_modules/.bin/apm", File.join($binPath, "apm"))
      symlink_path("/Applications/Atom.app/Contents/Resources/app/atom.sh", File.join($binPath, "atom"))
    end

    if File.exists?("/Applications/TextMate.app")
      symlink_path("/Applications/TextMate.app/Contents/Resources/mate", File.join($binPath, "mate"))
    end

    if File.exists?("/Applications/SourceTree.app")
      symlink_path("/Applications/SourceTree.app/Contents/Resources/stree", File.join($binPath, "stree"))
    end

    if File.exists?("/Applications/Tower.app")
      symlink_path("/Applications/Tower.app/Contents/MacOS/gittower", File.join($binPath, "gittower"))
    end
  end

  task :local do
    $localFiles.each {|f|
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
  if $windows then
     real_path=`readlink -f #{path}`
     return `cygpath #{real_path}`.strip
  end
  return Pathname.new(path).realpath()
end

def readlink(path)
  return `readlink "#{path}"`.strip
end

def is_symlink(path)
  return readlink(path) != ""
end

def do_symlink(source, dest)
  sh "ln -s '#{source}' '#{dest}'"
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
