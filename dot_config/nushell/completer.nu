let fish_completer = {|spans|
    # If the current command is an alias, get its expansion
    let expanded_alias = (scope aliases | where name == $spans.0 | get -i 0 | get -i expansion)

    # Overwrite spans if an alias is expanded
    let spans = (if $expanded_alias != null  {
        # Put the first word of the expanded alias first in the span
        $spans | skip 1 | prepend ($expanded_alias | split row " " | take 1)
    } else { $spans })

    # Use Fish for completions
    fish --command $'complete "--do-complete=($spans | str join " ")"'
    | $"value(char tab)description(char newline)" + $in
    | from tsv --flexible --no-infer
}
# 
# $env.config = {
#     completions: {
#         external: {
#             enable: true
#             completer: $fish_completer
#         }
#     }
# }

let zoxide_completer = {|spans|
    $spans | skip 1 | zoxide query -l ...$in | lines | where {|x| $x != $env.PWD}
}

let carapace_completer = {|spans: list<string>|
    carapace $spans.0 nushell ...$spans
    | from json
    | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) { $in } else { null }
}

$env.ARGC_COMPLETIONS_ROOT = '/home/brauni/.config/argc-completions'
$env.ARGC_COMPLETIONS_PATH = ($env.ARGC_COMPLETIONS_ROOT + '/completions/linux:' + $env.ARGC_COMPLETIONS_ROOT + '/completions')
$env.PATH = ($env.PATH | prepend ($env.ARGC_COMPLETIONS_ROOT + '/bin'))
# argc --argc-completions nushell | save -f '/home/brauni/.config/argc-completions/tmp/argc-completions.nu'
# source '/home/brauni/.config/argc-completions/tmp/argc-completions.nu'

def _argc_completer [args: list<string>] {
    argc --argc-compgen nushell "" ...$args
        | split row "\n"
        | each { |line| $line | split column "\t" value description }
        | flatten 
}
let argc_completer = {|spans| 
    _argc_completer $spans
}


# This completer will use carapace by default
let external_completer = {|spans|
    let expanded_alias = scope aliases
    | where name == $spans.0
    | get -i 0.expansion

    let spans = if $expanded_alias != null {
        $spans
        | skip 1
        | prepend ($expanded_alias | split row ' ' | take 1)
    } else {
        $spans
    }

    match $spans.0 {
        # carapace completions are incorrect for nu
        # nu => $fish_completer
        # # fish completes commits and branch names in a nicer way
        # git => $fish_completer
        # talosctl => $fish_completer
        # kubectl => $fish_completer
        # # carapace doesn't have completions for asdf
        # asdf => $fish_completer
        # # use zoxide completions for zoxide commands
        # __zoxide_z | __zoxide_zi => $zoxide_completer
        _ => $argc_completer
    } | do $in $spans
}

$env.config = {
    # ...
    completions: {
        external: {
            enable: true
            completer: $external_completer
        }
    }
    # ...
}
