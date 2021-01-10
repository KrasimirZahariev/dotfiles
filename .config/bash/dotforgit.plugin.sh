# MIT (c) Wenxuan Zhang

# ** Slightly modified version so it can be used with git bare repository

dotforgit::warn() { printf "%b[Warn]%b %s\n" '\e[0;33m' '\e[0m' "$@" >&2; }
dotforgit::info() { printf "%b[Info]%b %s\n" '\e[0;32m' '\e[0m' "$@" >&2; }
dotforgit::inside_work_tree() { $dotfiles rev-parse --is-inside-work-tree >/dev/null; }

# https://github.com/wfxr/emoji-cli
# hash emojify &>/dev/null && dotforgit_emojify='|emojify'

# work with the bare repo
bare_repo_location="$HOME/.dotfiles"
dotfiles="git --git-dir=$bare_repo_location --work-tree=$HOME"

dotforgit_pager=$($dotfiles config core.pager || echo 'cat')

# dotfiles commit viewer
dotforgit::log() {
    dotforgit::inside_work_tree || return 1
    local cmd opts
    cmd="echo {} |grep -Eo '[a-f0-9]+' |head -1 |xargs -I% $dotfiles show --color=always % $* | $dotforgit_pager"
    opts="
        $FORGIT_FZF_DEFAULT_OPTS
        +s +m --tiebreak=index --preview=\"$cmd\"
        --bind=\"enter:execute($cmd | LESS='-R' less)\"
        --bind=\"ctrl-y:execute-silent(echo {} |grep -Eo '[a-f0-9]+' | head -1 | tr -d '\n' |${FORGIT_COPY_CMD:-pbcopy})\"
        $FORGIT_LOG_FZF_OPTS
    "
    eval "$dotfiles log --graph --color=always --format='%C(auto)%h%d %s %C(black)%C(bold)%cr' $* $dotforgit_emojify" |
        FZF_DEFAULT_OPTS="$opts" fzf
}

# dotfiles diff viewer
dotforgit::diff() {
    dotforgit::inside_work_tree || return 1
    local cmd files opts commit repo
    [[ $# -ne 0 ]] && {
        if $dotfiles rev-parse "$1" -- &>/dev/null ; then
            commit="$1" && files=("${@:2}")
        else
            files=("$@")
        fi
    }

    repo="$($dotfiles rev-parse --show-toplevel)"
    target="\$(echo {} | sed 's/.*]  //')"
    cmd="$dotfiles diff --color=always $commit -- $repo/$target | $dotforgit_pager"
    opts="
        $FORGIT_FZF_DEFAULT_OPTS
        +m -0 --preview=\"$cmd\" --bind=\"enter:execute($cmd |LESS='-R' less)\"
        $FORGIT_DIFF_FZF_OPTS
    "
    eval "$dotfiles diff --name-status $commit -- ${files[*]} | sed -E 's/^(.)[[:space:]]+(.*)$/[\1]  \2/'" |
        FZF_DEFAULT_OPTS="$opts" fzf
}

# dotfiles add selector
# remove -u option from git status (don't list untracked files)
dotforgit::add() {
    dotforgit::inside_work_tree || return 1
    # add only tracked files with "."
    [[ $1 = "." ]] && $dotfiles add -u && return
    # Add files if passed as arguments
    [[ $# -ne 0 ]] && $dotfiles add "$@" && return

    local changed unmerged untracked files opts preview extract
    changed=$($dotfiles config --get-color color.status.changed red)
    unmerged=$($dotfiles config --get-color color.status.unmerged red)
    untracked=$($dotfiles config --get-color color.status.untracked red)

    # NOTE: paths listed by '$dotfiles status -s' mixed with quoted and unquoted style
    # remove indicators | remove original path for rename case | remove surrounding quotes
    extract="
        sed 's/^.*]  //' |
        sed 's/.* -> //' |
        sed -e 's/^\\\"//' -e 's/\\\"\$//'"
    preview="
        file=\$(echo {} | $extract)
        if ($dotfiles status -s -- \$file | grep '^??') &>/dev/null; then  # diff with /dev/null for untracked files
            $dotfiles diff --color=always --no-index -- /dev/null \$file | $dotforgit_pager | sed '2 s/added:/untracked:/'
        else
            $dotfiles diff --color=always -- \$file | $dotforgit_pager
        fi"
    opts="
        $FORGIT_FZF_DEFAULT_OPTS
        -0 -m --nth 2..,..
        --preview=\"$preview\"
        $FORGIT_ADD_FZF_OPTS
    "
    files=$($dotfiles -c color.status=always -c status.relativePaths=true status -s |
        grep -F -e "$changed" -e "$unmerged" -e "$untracked" |
        sed -E 's/^(..[^[:space:]]*)[[:space:]]+(.*)$/[\1]  \2/' |
        FZF_DEFAULT_OPTS="$opts" fzf |
        sh -c "$extract")
    [[ -n "$files" ]] && echo "$files"| tr '\n' '\0' |xargs -0 -I% $dotfiles add % && $dotfiles status -s && return
    echo 'Nothing to add.'
}

# dotfiles reset HEAD (unstage) selector
dotforgit::reset::head() {
    dotforgit::inside_work_tree || return 1
    local cmd files opts
    cmd="$dotfiles diff --cached --color=always -- {} | $dotforgit_pager "
    opts="
        $FORGIT_FZF_DEFAULT_OPTS
        -m -0 --preview=\"$cmd\"
        $FORGIT_RESET_HEAD_FZF_OPTS
    "
    files="$($dotfiles diff --cached --name-only --relative | FZF_DEFAULT_OPTS="$opts" fzf)"
    [[ -n "$files" ]] && echo "$files" | tr '\n' '\0' | xargs -0 -I% $dotfiles reset -q HEAD % && $dotfiles status --short && return
    echo 'Nothing to unstage.'
}

# dotfiles checkout-restore selector
dotforgit::restore() {
    dotforgit::inside_work_tree || return 1
    local cmd files opts
    cmd="$dotfiles diff --color=always -- {} | $dotforgit_pager"
    opts="
        $FORGIT_FZF_DEFAULT_OPTS
        -m -0 --preview=\"$cmd\"
        $FORGIT_CHECKOUT_FZF_OPTS
    "
    files="$($dotfiles ls-files --modified "$($dotfiles rev-parse --show-toplevel)"| FZF_DEFAULT_OPTS="$opts" fzf)"
    [[ -n "$files" ]] && echo "$files" | tr '\n' '\0' | xargs -0 -I% $dotfiles checkout % && $dotfiles status --short && return
    echo 'Nothing to restore.'
}

# dotfiles stash viewer
dotforgit::stash::show() {
    dotforgit::inside_work_tree || return 1
    local cmd opts
    cmd="$dotfiles stash show \$(echo {}| cut -d: -f1) --color=always --ext-diff | $dotforgit_pager"
    opts="
        $FORGIT_FZF_DEFAULT_OPTS
        +s +m -0 --tiebreak=index --preview=\"$cmd\" --bind=\"enter:execute($cmd | LESS='-R' less)\"
        $FORGIT_STASH_FZF_OPTS
    "
    $dotfiles stash list | FZF_DEFAULT_OPTS="$opts" fzf
}

# dotfiles clean selector
dotforgit::clean() {
    dotforgit::inside_work_tree || return 1
    local files opts
    opts="
        $FORGIT_FZF_DEFAULT_OPTS
        -m -0
        $FORGIT_CLEAN_FZF_OPTS
    "
    # Note: Postfix '/' in directory path should be removed. Otherwise the directory itself will not be removed.
    files=$($dotfiles clean -xdfn "$@"| sed 's/^Would remove //' | FZF_DEFAULT_OPTS="$opts" fzf |sed 's#/$##')
    [[ -n "$files" ]] && echo "$files" | tr '\n' '\0' | xargs -0 -I% $dotfiles clean -xdf '%' && return
    echo 'Nothing to clean.'
}

# dotfiles ignore generator
export FORGIT_GI_REPO_REMOTE=${FORGIT_GI_REPO_REMOTE:-https://github.com/dvcs/gitignore}
export FORGIT_GI_REPO_LOCAL="${FORGIT_GI_REPO_LOCAL:-${XDG_CACHE_HOME:-$HOME/.cache}/forgit/gi/repos/dvcs/gitignore}"
export FORGIT_GI_TEMPLATES=${FORGIT_GI_TEMPLATES:-$FORGIT_GI_REPO_LOCAL/templates}

dotforgit::ignore() {
    [ -d "$FORGIT_GI_REPO_LOCAL" ] || dotforgit::ignore::update
    local IFS cmd args cat opts
    # https://github.com/sharkdp/bat.$dotfiles
    hash bat &>/dev/null && cat='bat -l gitignore --color=always' || cat="cat"
    cmd="$cat $FORGIT_GI_TEMPLATES/{2}{,.gitignore} 2>/dev/null"
    opts="
        $FORGIT_FZF_DEFAULT_OPTS
        -m --preview=\"$cmd\" --preview-window='right:70%'
        $FORGIT_IGNORE_FZF_OPTS
    "
    # shellcheck disable=SC2206,2207
    IFS=$'\n' args=($@) && [[ $# -eq 0 ]] && args=($(dotforgit::ignore::list | nl -nrn -w4 -s'  ' |
        FZF_DEFAULT_OPTS="$opts" fzf  |awk '{print $2}'))
    [ ${#args[@]} -eq 0 ] && return 1
    # shellcheck disable=SC2068
    if hash bat &>/dev/null; then
        dotforgit::ignore::get ${args[@]} | bat -l gitignore
    else
        dotforgit::ignore::get ${args[@]}
    fi
}
dotforgit::ignore::update() {
    if [[ -d "$FORGIT_GI_REPO_LOCAL" ]]; then
        dotforgit::info 'Updating gitignore repo...'
        (cd "$FORGIT_GI_REPO_LOCAL" && $dotfiles pull --no-rebase --ff) || return 1
    else
        dotforgit::info 'Initializing gitignore repo...'
        $dotfiles clone --depth=1 "$FORGIT_GI_REPO_REMOTE" "$FORGIT_GI_REPO_LOCAL"
    fi
}
dotforgit::ignore::get() {
    local item filename header
    for item in "$@"; do
        if filename=$(find -L "$FORGIT_GI_TEMPLATES" -type f \( -iname "${item}.gitignore" -o -iname "${item}" \) -print -quit); then
            [[ -z "$filename" ]] && dotforgit::warn "No gitignore template found for '$item'." && continue
            header="${filename##*/}" && header="${header%.gitignore}"
            echo "### $header" && cat "$filename" && echo
        fi
    done
}
dotforgit::ignore::list() {
    find "$FORGIT_GI_TEMPLATES" -print |sed -e 's#.gitignore$##' -e 's#.*/##' | sort -fu
}
dotforgit::ignore::clean() {
    setopt localoptions rmstarsilent
    [[ -d "$FORGIT_GI_REPO_LOCAL" ]] && rm -rf "$FORGIT_GI_REPO_LOCAL"
}

FORGIT_FZF_DEFAULT_OPTS="
$FZF_DEFAULT_OPTS
--ansi
--height='100%'
--preview-window='right:80%'
--color='preview-bg:-1'
--bind='ctrl-a:toggle-all'
--bind='ctrl-p:toggle-preview'
--bind='alt-j:preview-down'
--bind='alt-d:preview-half-page-down'
--bind='alt-k:preview-up'
--bind='alt-u:preview-half-page-up'
$FORGIT_FZF_DEFAULT_OPTS
"

# register aliases
# shellcheck disable=SC2139
if [[ -z "$FORGIT_NO_ALIASES" ]]; then
    alias "${dotforgit_add:-ga}"='dotforgit::add'
    alias "${dotforgit_reset_head:-grh}"='dotforgit::reset::head'
    alias "${dotforgit_log:-gl}"='dotforgit::log'
    alias "${dotforgit_diff:-gd}"='dotforgit::diff'
    alias "${dotforgit_ignore:-gi}"='dotforgit::ignore'
    alias "${dotforgit_restore:-grs}"='dotforgit::restore'
    alias "${dotforgit_clean:-gclean}"='dotforgit::clean'
    alias "${dotforgit_stash_show:-gss}"='dotforgit::stash::show'
fi
