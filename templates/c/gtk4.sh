#!/bin/sh

set -e

echo "Do you want install gcc, cmake and Pkg-Config? (y/n): "
read answer

if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
    sudo apt update
    sudo apt install -y build-essential cmake pkg-config
else
    echo "Skipped installation."
fi

echo "Do you want install gtk4 for C? (y/n): "
read answer

if [ "$answer" = "y" ] || [ "$answer" = "y" ]; then
    sudo apt update
    sudo apt install libgtk-4-dev
else
    echo "Skipped gtk4 installation."
fi

mkdir -p src include build

cat << EOF > include/main_window.h
#ifndef MAIN_WINDOW_H
#define MAIN_WINDOW_H

#include <gtk/gtk.h>

void on_activate(GtkApplication *app);

#endif
EOF

cat << EOF > src/main.c
#include "main_window.h"

int main(int argc, char *argv[]){
    GtkApplication * app = gtk_application_new("my.project.gtk4", G_APPLICATION_DEFAULT_FLAGS);

    g_signal_connect(app, "activate", G_CALLBACK(on_activate), NULL);
    return g_application_run(G_APPLICATION(app), argc, argv);
}
EOF

cat << EOF > src/main_window.c
#include <stdio.h>
#include "main_window.h"

static void on_button_clicked(GtkWidget *button){
    printf("Hello, World!\n");
}

void on_activate(GtkApplication *app){
    GtkWidget *window = gtk_application_window_new(app);

    GtkWidget *button = gtk_button_new_with_label("Hello, World");
    g_signal_connect(button, "clicked", G_CALLBACK(on_button_clicked), NULL);

    gtk_window_set_child(GTK_WINDOW(window), button);
    gtk_window_present(GTK_WINDOW(window));
}
EOF

project_name="my_project"

if [ -n "$1" ]; then
    project_name="$1"
fi

cat << EOF > CMakeLists.txt
cmake_minimum_required(VERSION 3.16)
project(${project_name} LANGUAGES C)

set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

find_package(PkgConfig REQUIRED)

pkg_check_modules(GTK4 REQUIRED IMPORTED_TARGET gtk4)

add_executable(${project_name} 
    src/main.c
    src/main_window.c)

target_include_directories(${project_name} PRIVATE \${CMAKE_SOURCE_DIR}/include)

target_link_libraries(${project_name} PRIVATE PkgConfig::GTK4)
EOF

echo "Create $project_name c"

cmake -S . -B build
cmake --build build

git init