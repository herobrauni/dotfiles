export def carapace-completer [spans: list<string>] {
    carapace $spans.0 nushell ...$spans
    | from json
    | if ($in | default [] | any {|| $in.display? | default "" | str starts-with "ERR"}) { null } else { $in }
    | default []
    | each {|row|
        let val = $row.value
        
        # Only expand tildes, let Nushell handle quoting
        let fixed_val = if ($val | str starts-with "~") {
            $val | path expand
        } else {
            $val
        }
        
        $row | upsert value $fixed_val
    }
}

export def fish-completer [spans: list<string>] {
    fish --command $"complete '--do-complete=($spans | str replace --all "'" "\\'" | str join ' ')'"
    | from tsv --flexible --noheaders --no-infer
    | rename value description
    | each {|row|
        let val = $row.value
        
        # Check if quoting is needed on the ORIGINAL value
        let need_quote = ['\' ',' '[' ']' '(' ')' ' ' '\t' "'" '"' "`"] | any {$in in $val}
        
        # Only expand if it starts with tilde
        let fixed_val = if ($val | str starts-with "~") {
            let expanded = ($val | path expand)
            if $need_quote {
                $'"($expanded | str replace --all "\"" "\\\"")"'
            } else {
                $expanded
            }
        } else if $need_quote {
            $'"($val | str replace --all "\"" "\\\"")"'
        } else {
            $val
        }
        
        $row | upsert value $fixed_val
    }
}
