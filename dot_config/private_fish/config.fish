if status is-interactive
    # Commands to run in interactive sessions can go here
end

/var/home/linuxbrew/.linuxbrew/bin/brew shellenv | source
starship init fish | source
zoxide init fish | source
atuin init fish | source
<<<<<<< HEAD
set -gx PATH $PATH $HOME/.krew/bin

function fish_mode_prompt; true; end # Init vscode with a fish_mode_prompt with a non-empty function body
source (code --locate-shell-integration-path fish)

#string match -q "$TERM_PROGRAM" "vscode"; and . (code --locate-shell-integration-path fish)
=======

cd ~
>>>>>>> d32ac28655fce6aaa0bbe7f92151a5eeae6dbd8a
