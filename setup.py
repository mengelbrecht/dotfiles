#!/usr/bin/python

import glob
import os
import re


blacklist = set(["LICENSE", "README.md", "setup.py"])
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

    symlink(zpreztoPhysical, zpreztoLogical)

    for f in zpreztoLogicalFiles:
        symlink(f, os.path.join(home, "." + os.path.basename(f)))

def getDotfiles():
    dotfilesPhysical = [f for f in os.listdir(root) if os.path.isfile(f) and not f.startswith(".")]
    return [os.path.join(root, f) for f in (set(dotfilesPhysical) - blacklist)]

def setupDotfiles():
    dotfilesPhysical = getDotfiles()
    for f in dotfilesPhysical:
        symlink(f, os.path.join(home, "." + os.path.basename(f)))

setupZPrezto()
setupDotfiles()