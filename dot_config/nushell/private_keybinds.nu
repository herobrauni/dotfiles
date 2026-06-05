# Launch Atuin AI inline when typing '?' on an empty line and pressing Enter
def "?" [] {
    # Run atuin ai inline with --hook to get machine-parseable output.
    # e>| pipes stderr (markers) while stdout (TUI) passes to terminal.
    let output = (^atuin ai inline --hook e>| str trim)

    if ($output | str starts-with "__atuin_ai_execute__:") {
        # Execute the command immediately
        let cmd = ($output | str replace "__atuin_ai_execute__:" "")
        commandline edit --accept $cmd
    } else if ($output | str starts-with "__atuin_ai_insert__:") {
        # Insert the command for editing
        let cmd = ($output | str replace "__atuin_ai_insert__:" "")
        commandline edit --replace $cmd
    } else if ($output | str starts-with "__atuin_ai_print__:") {
        # Print text (conversational answer)
        let text = ($output | str replace "__atuin_ai_print__:" "")
        print $text
    } else if ($output == "__atuin_ai_cancel__") {
        # User cancelled — do nothing
    } else if ($output | is-not-empty) {
        # Fallback: insert for editing
        commandline edit --replace $output
    }
}

# ─── Aliases ───────────────────────────────────────────────────

alias ap = ansible-playbook
# ccd is a def below (chezmoi source-path, evaluated at call time)
alias ce = chezmoi edit
# cm left as chezmoi (shortcut)
alias cm = chezmoi
alias f = flux
alias ff = systemctl --user start app-org.mozilla.firefox@autostart.service
alias fr = flux reconcile source git flux-system
# gpush is a def below (custom commit message support)
alias k = kubectl
alias kh = kubectl get hr -A
alias kk = kubectl get ks -A
alias lg = lazygit
alias py = uv run
alias pypy = uv run --python pypy3
alias t = talosctl
alias th = talhelper
alias ts = tailscale ssh
alias y = yazi

# chezmoi source-path is evaluated every invocation (alias would freeze it)
def ccd [] {
    cd (chezmoi source-path)
}

# ─── Custom commands ───────────────────────────────────────────

def la [folder?] {
    match $folder {
        null => { ls -la | sort-by type name }
        _ => { ls -la $folder | sort-by type name }
    }
}

def gpush [message?: string] {
    git add .
    match $message {
        null => { git commit -m "update" }
        _ => { git commit -m $message }
    }
    git push
}

# ─── Fish-style inline autosuggestions (powered by atuin history) ───

$env.config.hinter.closure = {|ctx|
    if ($ctx.line | str length) == 0 {
        return null
    }
    let candidate = (try {
        ^atuin search --cwd $ctx.cwd --limit 1 --search-mode prefix --cmd-only $ctx.line
        | lines
        | first
    } catch {
        null
    })
    if $candidate == null or not ($candidate | str starts-with $ctx.line) {
        null
    } else {
        # Return the suffix to append (greyed-out portion)
        $candidate | str substring ($ctx.line | str length)..
    }
}

# ─── sudo toggle / sudo !! — Alt+S ─────────────────────────────
#   • Buffer has text: toggles sudo prefix (preserves cursor)
#   • Buffer empty:     redo last command with sudo

def _sudo_toggle [] {
    let buf = (commandline)

    if ($buf | str trim | is-empty) {
        # Empty buffer — get last history command with sudo
        let last = (history | last | get command | str trim)
        let cmd = if $last == "_sudo_toggle" {
            history | last 2 | first | get command | str trim
        } else {
            $last
        }
        if ($cmd | str starts-with "sudo ") {
            commandline edit --replace $cmd
        } else {
            commandline edit --replace $"sudo ($cmd)"
        }
    } else {
        # Toggle sudo on current buffer, preserving cursor position
        let cursor = (commandline get-cursor)
        if ($buf | str starts-with "sudo ") {
            let newbuf = ($buf | str replace --regex '^sudo ' '')
            commandline edit --replace $newbuf
            commandline set-cursor ($cursor - 5)
        } else {
            let newbuf = $"sudo ($buf)"
            commandline edit --replace $newbuf
            commandline set-cursor ($cursor + 5)
        }
    }
}

$env.config.keybindings = ($env.config.keybindings | default [] | append {
    name: sudo_toggle
    modifier: alt
    keycode: char_s
    mode: [emacs, vi_normal, vi_insert]
    event: { send: executehostcommand cmd: "_sudo_toggle" }
})
