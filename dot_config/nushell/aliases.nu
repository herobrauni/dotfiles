def bbic [] = { 
    brew update; 
    brew bundle install --cleanup --file=~/.config/Brewfile --no-lock; 
    brew upgrade; 
}
