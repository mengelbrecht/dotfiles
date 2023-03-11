function gpr -d "print git repository root"
    git rev-parse --show-toplevel
end

function cdg -d "cd to git repository root"
    cd (gpr)
end

if type -q lazygit
    alias lg lazygit
end

set tower_binary "/Applications/Tower.app/Contents/MacOS/gittower"

if test -x "$tower_binary"
    function tower -d "open tower at git repository root"
        if test (count $argv) -lt 1
            command "$tower_binary" (gpr)
        else
            pushd "$argv[1]"
            command "$tower_binary" (gpr)
            popd
        end
    end
end

# Copyright (c) 2009-2011 Robby Russell and contributors
# Copyright (c) 2011-2017 Sorin Ionescu and contributors
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:
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
# SOFTWARE

# https://github.com/sorin-ionescu/prezto/blob/c4a8f446c6d7d67e675d60c055ae8098dc8af9fe/modules/git/alias.zsh

set git_log_brief_format '%C(green)%h%C(reset) %s%n%C(blue)(%ar by %an)%C(red)%d%C(reset)%n'
set git_log_oneline_format '%C(auto,yellow)%h %C(auto,green)%ad%C(auto,red)%d %C(auto,reset)%s%C(auto,blue) [%cn]%C(auto,reset)'
set git_log_medium_format '%C(bold)Commit:%C(reset) %C(green)%H%C(red)%d%n%C(bold)Author:%C(reset) %C(cyan)%an <%ae>%n%C(bold)Date:%C(reset)   %C(blue)%ai (%ar)%C(reset)%n%+B'

# Git
alias g git

# Branch (b)
alias gb "git branch"
alias gba "git branch --all --verbose"
alias gbc "git checkout -b"
alias gbd "git branch --delete"
alias gbD "git branch --delete --force"
alias gbl "git branch --verbose"
alias gbL "git branch --all --verbose"
alias gbm "git branch --move"
alias gbM "git branch --move --force"
alias gbr "git branch --move"
alias gbR "git branch --move --force"
alias gbs "git show-branch"
alias gbS "git show-branch --all"
alias gbv "git branch --verbose"
alias gbV "git branch --verbose --verbose"
alias gbx "git branch --delete"
alias gbX "git branch --delete --force"

# Commit (c)
alias gc "git commit --verbose"
alias gcS "git commit --verbose --gpg-sign"
alias gca "git commit --verbose --all"
alias gcaS "git commit --verbose --all --gpg-sign"
alias gcm "git commit --message"
alias gcmS "git commit --message --gpg-sign"
alias gcam "git commit --all --message"
alias gco "git checkout"
alias gcO "git checkout --patch"
alias gcf "git commit --amend --reuse-message HEAD"
alias gcfS "git commit --amend --reuse-message HEAD --gpg-sign"
alias gcF "git commit --verbose --amend"
alias gcFS "git commit --verbose --amend --gpg-sign"
alias gcp "git cherry-pick --ff"
alias gcP "git cherry-pick --no-commit"
alias gcr "git revert"
alias gcR "git reset "HEAD^""
alias gcs "git show"
alias gcsS "git show --pretty=short --show-signature"
alias gcl git-commit-lost
alias gcy "git cherry --verbose --abbrev"
alias gcY "git cherry --verbose"

# Fetch (f)
alias gf "git fetch"
alias gfa "git fetch --all"
alias gfc "git clone"
alias gfcr "git clone --recurse-submodules"
alias gfm "git pull"
alias gfma "git pull --autostash"
alias gfr "git pull --rebase"
alias gfra "git pull --rebase --autostash"

# Index (i)
alias gia "git add"
alias giA "git add --patch"
alias giu "git add --update"
alias gid "git diff --no-ext-diff --cached"
alias giD "git diff --no-ext-diff --cached --word-diff"
alias gii "git update-index --assume-unchanged"
alias giI "git update-index --no-assume-unchanged"
alias gir "git reset"
alias giR "git reset --patch"
alias gix "git rm -r --cached"
alias giX "git rm -r --force --cached"

# Log (l)
alias gl="git log --topo-order --pretty=format:'$git_log_medium_format'"
alias gls="git log --topo-order --stat --pretty=format:'$git_log_medium_format'"
alias gld="git log --topo-order --stat --patch --full-diff --pretty=format:'$git_log_medium_format'"
alias glo="git log --topo-order --pretty=format:'$git_log_oneline_format'"
alias glg="git log --topo-order --graph --pretty=format:'$git_log_oneline_format'"
alias glb="git log --topo-order --pretty=format:'$git_log_brief_format'"
alias glc "git shortlog --summary --numbered"

# Merge (m)
alias gm "git merge"
alias gmC "git merge --no-commit"
alias gmF "git merge --no-ff"
alias gma "git merge --abort"
alias gmt "git mergetool"

# Push (p)
alias gp "git push"
alias gpf "git push --force-with-lease"
alias gpF "git push --force"
alias gpa "git push --all"
alias gpA "git push --all && git push --tags"
alias gpt "git push --tags"

# Rebase (r)
alias gr "git rebase"
alias gra "git rebase --abort"
alias grc "git rebase --continue"
alias gri "git rebase --interactive"
alias grs "git rebase --skip"

# Remote (R)
alias gR "git remote"
alias gRl "git remote --verbose"
alias gRa "git remote add"
alias gRx "git remote rm"
alias gRm "git remote rename"
alias gRu "git remote update"
alias gRp "git remote prune"
alias gRs "git remote show"
alias gRb git-hub-browse

# Stash (s)
alias gs "git stash"
alias gsa "git stash apply"
alias gsx "git stash drop"
alias gsX git-stash-clear-interactive
alias gsl "git stash list"
alias gsL git-stash-dropped
alias gsd "git stash show --patch --stat"
alias gsp "git stash pop"
alias gsr git-stash-recover
alias gss "git stash save --include-untracked"
alias gsS "git stash save --patch --no-keep-index"
alias gsw "git stash save --include-untracked --keep-index"

# Submodule (S)
alias gS "git submodule"
alias gSa "git submodule add"
alias gSf "git submodule foreach"
alias gSi "git submodule init"
alias gSI "git submodule update --init --recursive"
alias gSl "git submodule status"
alias gSm git-submodule-move
alias gSs "git submodule sync"
alias gSu "git submodule update --remote --recursive"
alias gSx git-submodule-remove

# Tag (t)
alias gt "git tag"
alias gtl "git tag --list"
alias gts "git tag --sign"
alias gtv "git verify-tag"

# Working Copy (w)
alias gws "git status --short"
alias gwS "git status"
alias gwd "git diff --no-ext-diff"
alias gwD "git diff --no-ext-diff --word-diff"
alias gwr "git reset --soft"
alias gwR "git reset --hard"
alias gwc "git clean --dry-run"
alias gwC "git clean --force"
alias gwx "git rm -r"
alias gwX "git rm -r --force"

# Additional git aliases for Cleanup and Restore (X)
alias gXc='git clean -dxf'
alias gXr='git reset --hard HEAD'
alias gXw='gXr && gXc'
