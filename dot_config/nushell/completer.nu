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

$env.config = {
    completions: {
        external: {
            enable: true
            completer: $fish_completer
        }
    }
}
