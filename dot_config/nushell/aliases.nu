if $env.PWD == /var/home/brauni {
	cd /home/brauni
}

alias cm = chezmoi

def la [folder?] { 
	match $folder {
		null => { ls -la | sort-by type name }
		_ => { ls -la $folder | sort-by type name }
	}
}

def bbic [] = { 
    brew update; 
    brew bundle install --cleanup --file=~/.config/Brewfile --no-lock; 
    brew upgrade; 
}

def gpush [message?: string] = {
    git add .
    match $message {
        null => { git commit -m "update"}
        _ => { git commit -m $message }
    }
    git push
}

alias ccd = cd (chezmoi source-path)

alias bitpw = rbw get (rbw list | fzf) --full
def bitcode [] = {
	let pin = (rbw code (rbw list | fzf))
	print $pin
	$pin | wl-copy
}
alias neofetch = fastfetch
alias fastfetch = /usr/bin/fastfetch --file /usr/share/ublue-os/aurora-logo.txt --logo-type file --logo-color-1 94 --logo-color-2 95 --logo-color-3 91  --logo-color-4 97 -c /usr/share/ublue-os/ublue-os.jsonc

def uu [] = {
	ublue-update --wait
	/usr/bin/topgrade --config ~/.config/topgrade.toml --keep
}

alias ff = systemctl --user start app-org.mozilla.firefox@autostart.service


$env.config = (
    $env.config | upsert keybindings (
        $env.config.keybindings
        | append {
            name: atuin
            modifier: none
            keycode: up
            mode: [emacs, vi_normal, vi_insert]
            event: {
            	send: executehostcommand
            	cmd: "commandline edit (atuin search --format \"{host}::{time}::{command}\" 
            	| parse '{host}::{time}::{command}' 
            	| get command 
            	| reverse 
            	| uniq
            	| str join (char -i 0) 
            	| fzf --scheme history --read0 --tiebreak=chunk --height=60% --preview='echo {..}' -q (commandline) --preview='echo -n {} | nu --stdin -c \'nu-highlight\''
            	| decode utf-8
            	| str trim
            	)"
            }
        }
    )
)
