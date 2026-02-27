#!/bin/sh

set -e

echo "Do you want install gcc, cmake and Pkg-Config? (y/n): "
read anwser

if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
    sudo apt update
    sudo apt install -y build-essential cmake pkg-config
else
    echo "Skipped installation."
fi

echo "Do you want to install the ncurses libraries for c/cpp? (y/n): "
read answer

if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
    sudo apt update
    sudo apt install -y libncurses-dev
else
    echo "Skipped ncurses installation."
fi

mkdir -p src include build

cat << EOF > include/application.hpp
#ifndef NCURSES_APPLICATION_HPP
#define NCURSES_APPLICATION_HPP

#include <ncurses.h>

class Application
{
    public:
        Application();
        ~Application();

        int init();
    private:
        const int HEIGHT = 10;
        const int WIDTH = 30; 

        WINDOW *m_win;

        static WINDOW *create_win(int height, int width, int start_x, int start_y);
        static void destroy_win(WINDOW *local_win);
};
#endif
EOF

cat << EOF > src/main.cpp
#include "application.hpp"

int main() {
    Application app;

    return app.init();
}
EOF

cat << EOF > src/application.cpp
#include "application.hpp"

Application::Application() = default;

Application::~Application(){
    destroy_win(m_win);
}

int Application::init(){
    // Initialize the ncurses library
    initscr();            

    const int START_X = (COLS - WIDTH) / 2;
    const int START_Y = (LINES - HEIGHT) / 2;
    
    // Optional input/output settings
    raw();                // Disable line buffering (pick up keystrokes instantly).
    keypad(stdscr, TRUE); // Enables special keys (F1, arrow keys, etc.)
    noecho();             // It does not display what the user types on the screen.
    curs_set(0);

        // Text rendering
    // printw works like printf, but for ncurses.
    printw("Press any key to exit...");
    
    // Update the physical screen to show what's in the buffer.
    refresh();   

    m_win = create_win(HEIGHT, WIDTH, START_X, START_Y);

    // Waiting for user input.
    getch();              

    destroy_win(m_win);

    // Exit ncurses mode and restore the terminal.
    return endwin();           
}

WINDOW* Application::create_win(int height, int width, int start_x, int start_y){
    WINDOW *local_win;

    local_win = newwin(height, width, start_y, start_x);
    box(local_win, 0, 0);

    const int TXT_POS_X = 4;
    const int TXT_POS_Y = 8;

    mvwprintw(local_win, TXT_POS_X, TXT_POS_Y, "Hello, World!");

    wrefresh(local_win);

    return local_win;
}

void Application::destroy_win(WINDOW *local_win){
    wborder (local_win, ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ');
    wrefresh(local_win);
    delwin(local_win);
}
EOF

project_name="my_project_ncurses"

if [ -n "$1" ]; then
    project_name="$1"
fi

echo "Create $project_name cpp"

cat << EOF > CMakeLists.txt
cmake_minimum_required(VERSION 3.16)
project(${project_name} LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

find_package(PkgConfig REQUIRED)

pkg_check_modules(NCURSES REQUIRED ncurses)

add_executable(${project_name} 
    src/main.cpp
    src/application.cpp)

target_include_directories(${project_name} PRIVATE \${CMAKE_SOURCE_DIR}/include)

target_include_directories(${project_name} PRIVATE \${NCURSES_INCLUDE_DIRS})
target_link_libraries(${project_name} PRIVATE \${NCURSES_LIBRARIES})
EOF

cmake -S . -B build
cmake --build build