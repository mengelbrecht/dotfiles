#!/usr/bin/python

import glob
import os
import re
import subprocess

excludes = set(["LICENSE", "README.md", "setup.py"])
root = os.path.dirname(os.path.realpath(__file__))
home = os.path.expanduser("~")

def symlink(source, dest):
    if os.path.exists(dest) and os.path.islink(dest):
        os.unlink(dest)
    if not os.path.exists(dest):
        os.symlink(source, dest)
    else:
        print("error: target {0} already exists".format(dest))

def setupZPrezto():
    zpreztoPhysical = os.path.join(root, "zprezto")
    zpreztoLogical = os.path.join(home, ".zprezto")
    zpreztoPhysicalFiles = glob.glob(os.path.join(zpreztoPhysical, "runcoms", "z*"))
    zpreztoLogicalFiles = [os.path.join(zpreztoLogical, "runcoms", os.path.basename(f)) for f in zpreztoPhysicalFiles]

    for f in zpreztoLogicalFiles:
        symlink(f, os.path.join(home, "." + os.path.basename(f)))

def getDotfiles():
    dotfilesPhysical = [f for f in os.listdir(root) if not f.startswith(".")]
    return [os.path.join(root, f) for f in (set(dotfilesPhysical) - excludes)]

def setupDotfiles():
    dotfilesPhysical = getDotfiles()
    for f in dotfilesPhysical:
        symlink(f, os.path.join(home, "." + os.path.basename(f)))

def createLocalFiles():
    localFiles = ["Brewfile.apps.local", "gitconfig.local", "slate.js.local", "vimrc.local", "zshrc.local"]
    for f in localFiles:
        path = os.path.join(root, f)
        if not os.path.exists(path):
            open(path, 'w').close()

def checkInstallHomebrew():
    try:
        with open(os.devnull, 'w') as null:
            available = subprocess.Popen('brew', stdout=null, stderr=null).wait() == 1
    except OSError:
        available = False
    if not available:
        subprocess.call(r'ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"', shell=True)
        subprocess.call(r'brew tap phinze/homebrew-cask', shell=True)

createLocalFiles()
checkInstallHomebrew()
setupDotfiles()
setupZPrezto()
