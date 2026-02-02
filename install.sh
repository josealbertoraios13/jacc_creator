#!/bin/bash

# if any command returns an error, the script stops
set -e

# Variables that define the installation locations
INSTALL_DIR="$HOME/cpp_creator"
BIN_DIR="$HOME/.local/bin"

# creates a directory where will be installed this program
mkdir -p "$INSTALL_DIR"
cp -r ./* "$INSTALL_DIR"

# Allows this file to be executed.
chmod +x "$INSTALL_DIR/alcpp.sh"

mkdir -p "$BIN_DIR"

# Create a symbolic link so 'alcpp' can be run as a global command
# -s: symbolic, -f: force overwrite if exists
ln -sfv "$INSTALL_DIR/alcpp.sh" "$BIN_DIR/alcpp"

# Detect the active shell to determine the correct configuration file
case "$(basename "$SHELL")" in
    zsh)  
        RC="$HOME/.zshrc" 
        ;;
    bash) 
        RC="$HOME.bashrc" 
        ;;
    *)
        # Generic fallback for other shells (sh, dash, etc.)    
        RC=".profile" 
        ;;
esac

# Check if this file actually exists.
touch "$RC"

# Check if ".local/bin" is already in the config file.
# grep -q: quiet mode (returns exit status without printing output).
# !: logical NOT (proceeds if the string is NOT found).
if ! grep -q "$BIN_DIR" "$RC"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$RC"
fi

# Check if the installation was successful.
if [ -e "$BIN_DIR/alcpp" ]; then
    echo -e "Installation completed successfully."
    echo "Restart your terminal or use: 'source $RC'"
    echo "Use alcpp --help to view the available commands."
else
    echo "The installation failed."
    exit 1
fi

# Get the exact path to this script and store it in a variable.
SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# Go to home directory
cd "$HOME"

# Delete the installation directory.
rm -rfv $SCRIPT_DIR