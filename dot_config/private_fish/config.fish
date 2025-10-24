if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
    zoxide init fish | source
    atuin init fish | sed 's/-k up/up/' | source
end

# /var/home/linuxbrew/.linuxbrew/bin/brew shellenv | source

