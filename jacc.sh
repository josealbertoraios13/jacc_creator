# if any command returns an error, the script stops
set -e

# This function displays the list of projects.
project_list_function(){

cat << EOF
Project list:

1- base <PROJECT-NAME (optional) >
2- ncurses <PROJECT-NAME (optional)>
2- gtk <PROJECT-NAME (optional)>

EOF

}

# This function will decide which project script will be executed.
create_function(){

    # Check if the second parameter is empty
    if [ -z "$2" ]; then
        echo "You need to specify the project type." 
        project_list_function$
        exit 1
    fi  

    case "$2" in
        base)
            "$SCRIPT_DIR/base_project" "$3"
        ;;
        gtk)
            "$SCRIPT_DIR/gtk_project" "$3"
        ;;
        *)
            echo "Invalid project type. Use: 'alcpp -h' or 'alcpp --help' to list possible commands."
        ;;
    esac
}

# Get the exact path to this script and store it in a variable.
SCRIPT_DIR="$(dirname "$(realpath "$0")")"

case "$1" in 
    "create")
        create_function "$@"
        ;;
    "project-list")
        project_list_function
        ;;
    "--version"|"-v")
        echo "alcpp: 0.1.5"
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

Create new cpp project:
    use: 'create <PROJECT-TYPE> <PROJECT-NAME (optional)>'

EOF

        project_list_function
        ;;
    *)
        echo "Invalid command. Use: 'alcpp -h' or 'alcpp --help' to list possible commands."
        ;;

esac