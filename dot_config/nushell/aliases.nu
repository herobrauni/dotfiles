if $env.PWD == /var/home/brauni {
	cd /home/brauni
}

alias cm = chezmoi

alias cat = bat

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

def update [] = {
	ublue-update --wait
	/usr/bin/topgrade --config ~/.config/topgrade.toml --keep
}
