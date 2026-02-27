#!/bin/sh

# if any command returns an error, the script stops
set -e

# Get the exact path to this script and store it in a variable.
SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# This function displays the list of projects.
project_list_function(){
cat << EOF
Project list:

C and C++
1- Base: <LANGUAGE ('c' or 'cpp')> base <PROJECT-NAME (optional)>
2- GTK3: <LANGUAGE ('c' or 'cpp')> gtk3 <PROJECT-NAME (optional)>
3- GTK4: <LANGUAGE ('c' or 'cpp')> gtk4 <PROJECT-NAME (optional)>
4- NCURSES: <LANGUAGE ('c' or 'cpp')> ncurses <PROJECT-NAME (optional)>
EOF
}

# This function will decide which project script will be executed.
create_function(){

    # Check if the second and third parameters is empty
    if [ -z "$2" ] || [ -z "$3" ]; then
        echo "Error: You must specify language and project type."
        project_list_function
        exit 1
    fi

    if [ ! -d "$SCRIPT_DIR/templates/$2" ]; then
        echo "Error: Language '$2' is not supported."
        echo "Available languages: $(ls -m "$SCRIPT_DIR/templates/")"
        exit 1
    fi

    TEMPLATE_PATH="$SCRIPT_DIR/templates/$2/$3.sh"

    if [ -f "$TEMPLATE_PATH" ]; then
        bash "$TEMPLATE_PATH" "$4"
    else
        echo "Error: Project type '$3' not found for $2."
        exit 1
    fi
}

case "$1" in 
    "create")
        create_function "$@"
        ;;
    "project-list")
        project_list_function
        ;;
    "--version"|"-v")
        echo "jacc: 0.2.5"
        ;;
    "--help"|"-h")

cat << EOF
==========================
|       COMAND LIST      |
==========================

Ask for help:
    use: '-h' or '--help'

Get program version: 
    use: '-v' or '--version'

Get project list:
    use: 'project-list'

Create new C or C++ project:
    use: 'create < c or cpp> <PROJECT-TYPE> <PROJECT-NAME (optional)>'

EOF
        project_list_function
        ;;
    *)
        echo "Invalid command. Use: 'jacc -h' or 'jacc --help' to list possible commands."
        ;;
esac