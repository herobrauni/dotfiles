if status is-interactive
    # Commands to run in interactive sessions can go here
end

# /var/home/linuxbrew/.linuxbrew/bin/brew shellenv | source
starship init fish | source
zoxide init fish | source
atuin init fish | source
fish_add_path .local/bin
