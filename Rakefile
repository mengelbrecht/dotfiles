require 'pathname'
require 'tempfile'

task :default => :update

task :setup => ["setup:setup"]

verbose(false)

$excludes = ["LICENSE", "README.md", "Rakefile", "osx.bash", "Xcode", "Terminal", "TextMate"]
$root = File.expand_path(File.dirname(__FILE__))
$home = File.expand_path("~")
$osx = RUBY_PLATFORM.include? "darwin"
$linux = RUBY_PLATFORM.include? "linux"
$exaVersion = "0.2.0"

namespace :setup do
  task :setup => [:osx, :homebrew, :local, :dotfiles, :exa]

  task :osx do
    next unless $osx
    sh File.join($root, "osx.bash")
  end

  task :homebrew do
    `which brew &> /dev/null`
    unless $?.success?
      info("installing homebrew")
      sh 'ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"' if $osx
      sh 'ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/linuxbrew/go/install)"' if $linux
    end

    installed_packages = `brew list`
    packages = ['git']
    packages.each {|name|
      if installed_packages.include?(name)
        info("skipping installation of package '#{name}', already installed")
      else
        sh "brew install #{name}"
      end
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

  task :exa do
    tempFile = Tempfile.new(['exa', '.zip'])
    tempFile.close
    exaDir = '/usr/local/bin'
    exaVersion = "0.0.0"

    `which exa &> /dev/null`
    if $?.success?
      exaVersion = `exa --version`.split(' ')[1]
    end
    if $exaVersion > exaVersion
      info("upgrading exa from #{exaVersion} to #{$exaVersion}")
      sh "curl -s -L -o #{tempFile.path} https://github.com/ogham/exa/releases/download/v#{$exaVersion}/exa-osx-x86_64.zip"
      sh "unzip -q #{tempFile.path} -d #{exaDir}"
      symlink_path(File.join(exaDir, 'exa-osx-x86_64'), File.join(exaDir, 'exa'))
      tempFile.unlink
      next
    end
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

def symlink_path(source, dest)
  if not File.exists?(dest) and File.symlink?(dest)
    info("deleting broken symlink '#{dest}' to '#{File.readlink(dest)}'")
    File.delete(dest)
  end
  if File.exists?(dest)
    if File.symlink?(dest)
      return if Pathname.new(source).realpath() == Pathname.new(dest).realpath()

      warning("deleting unknown symlink '#{dest}' to '#{Pathname.new(dest).realpath()}'")
      File.delete(dest)
    else
      backup = "#{dest}.#{Time.now.strftime("%Y%m%d%H%M%S")}"
      warning("target '#{dest}' already exists, backing up to '#{backup}'")
      File.rename(dest, backup)
    end
  end
  File.symlink(source, dest)
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
