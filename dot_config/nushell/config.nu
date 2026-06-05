$env.config.buffer_editor = "nano"

source ~/.local/share/atuin/pty-proxy-init.nu
source ~/.local/share/atuin/init.nu

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

source ~/.config/nushell/zoxide.nu
source ~/.config/nushell/mise.nu

source ~/.config/nushell/completions.nu
source ~/.config/nushell/keybinds.nu

$env.config.completions.external = {
    enable: true
    max_results: 100
    completer: {|spans|
        let carapace = (carapace-completer $spans)
        if ($carapace | is-not-empty) { $carapace } else { fish-completer $spans }
    }
}
