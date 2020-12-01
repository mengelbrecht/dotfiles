require 'pathname'
require 'tempfile'
require 'English'

#------------------------------------------------------------------------------
task default: %w(update)
task setup: %w(dotfiles)

verbose(false)

#------------------------------------------------------------------------------
ROOT = File.expand_path(File.dirname(__FILE__))
HOME = File.expand_path('~')
MACOS = RUBY_PLATFORM.include? 'darwin'
LINUX = RUBY_PLATFORM.include? 'linux'

#------------------------------------------------------------------------------
DOTFILES = [
  'config',
  'zshenv'
].freeze

LOCAL_FILES = [
  'config/git/config.local',
  'config/zsh/config.local'
].freeze

#------------------------------------------------------------------------------
task :dotfiles do
  DOTFILES.map { |f|
    symlink_path(File.join(ROOT, f), File.join(HOME, ".#{File.basename(f)}"))
  }

  LOCAL_FILES.map { |f| File.join(ROOT, f) }.select { |f| !File.exist?(f) }.each do |f|
    FileUtils.touch(f)
    info("created empty local file '#{f}'")
  end
end

task :update do
  sh 'git pull'
  sh 'git submodule update --init --recursive'
end

#------------------------------------------------------------------------------
# Extend String with coloring functions
class String
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
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

def realpath(path)
  Pathname.new(path).realpath
end

def readlink(path)
  `readlink "#{path}"`.strip
end

def symlink?(path)
  readlink(path) != ''
end

def delete_broken_symlink(dest)
  info("deleting broken symlink '#{dest}' to '#{readlink(dest)}'")
  File.delete(dest)
end

def backup_existing_symlink(dest)
  backup = "#{dest}.#{Time.now.strftime('%Y%m%d%H%M%S')}"
  warning("target '#{dest}' already exists, backing up to '#{backup}'")
  File.rename(dest, backup)
end

def symlink_path(source, dest)
  if File.exist?(dest)
    return if realpath(source) == realpath(dest)
    backup_existing_symlink(dest)
  end
  delete_broken_symlink(dest) if !File.exist?(dest) && symlink?(dest)
  sh "ln -s '#{source}' '#{dest}'"
  info("symlinked '#{source}' to '#{dest}'")
end

def info(msg, *args)
  puts "#{'info'.green}: #{msg % args}"
end

def warning(msg, *args)
  puts "#{'warning'.yellow}: #{msg % args}"
end

def error(msg, *args)
  puts "#{'error'.red}: #{msg % args}"
end
