# The MIT License (MIT)
#
# Copyright (c) 2018 Oh My Fish!
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# https://raw.githubusercontent.com/oh-my-fish/plugin-osx/d6a78545b70bdbb42c13266b23b44b530138ba67/functions/pfd.fish
function pfd -d "print the path of the current Finder window"
    osascript 2>/dev/null -e '
      tell application "Finder"
        return POSIX path of (target of window 1 as alias)
      end tell'
end

# https://raw.githubusercontent.com/oh-my-fish/plugin-osx/d6a78545b70bdbb42c13266b23b44b530138ba67/functions/cdf.fish
function cdf -d "cd to the current Finder directory"
    cd (pfd)
end
