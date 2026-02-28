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

echo "Do you want install gtk3 for C? (y/n): "
read answer

if [ "$answer" = "y" ] || [ "$answer" = "y" ]; then
    sudo apt update
    sudo apt install -y libgtk-3-dev
else
    echo "Skipped gtk3 installation."
fi

mkdir -p src include build

cat << EOF > include/main_window.h
#ifndef MAIN_WINDOW_H
#define MAIN_WINDOW_H

#include <gtk/gtk.h> 

void activate(GtkApplication *app, gpointer user_data);

#endif
EOF

cat << EOF > src/main.c
#include "main_window.h"

int main(int argc,  char *argv[]){
    GtkApplication *app;
    int status;

    app = gtk_application_new("my.project.gtk3", G_APPLICATION_DEFAULT_FLAGS);
    g_signal_connect(app, "activate", G_CALLBACK(activate), NULL);
    status = g_application_run(G_APPLICATION(app), argc, argv);
    g_object_unref(app);

    return status;
}
EOF

cat << EOF > src/main_window.c
#include <stdio.h>
#include "main_window.h"

static void on_button_clicked(GtkWidget *widget, gpointer data){
    printf("Hello, World!\n");
}

void activate(GtkApplication *app, gpointer user_data){
    GtkWidget *window;
    GtkWidget *button;
    GtkWidget *button_box;

    window = gtk_application_window_new(app);
    gtk_window_set_title(GTK_WINDOW(window), "my_project_gtk3");

    button_box = gtk_button_box_new(GTK_ORIENTATION_HORIZONTAL);
    gtk_container_add(GTK_CONTAINER(window), button_box);

    button = gtk_button_new_with_label("Hello, World");
    g_signal_connect(button, "clicked", G_CALLBACK(on_button_clicked), NULL);
    gtk_container_add(GTK_CONTAINER(button_box), button);

    gtk_widget_show_all(window);
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

pkg_check_modules(GTK3 REQUIRED IMPORTED_TARGET gtk+-3.0)

add_executable(${project_name} 
    src/main.c
    src/main_window.c)

target_include_directories(${project_name} PRIVATE \${CMAKE_SOURCE_DIR}/include)

target_link_libraries(${project_name} PRIVATE PkgConfig::GTK3)
EOF

echo "Create $project_name c"

cmake -S . -B build
cmake --build build

git init