export PATH="$PATH:/opt/mssql-tools/bin"

if [ -n "$BASH_VERSION" -a -n "$PS1" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
    fi
fi
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
. "$HOME/.cargo/env"


# Added by Toolbox App
export PATH="$PATH:/home/vit/.local/share/JetBrains/Toolbox/scripts"

