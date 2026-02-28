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

mkdir -p src include build

cat << EOF > src/main.c
#include <stdio.h>

int main(int argc, char *argv[]){
    printf("Hello, World!\n");

    return 0;
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

add_executable(${project_name} src/main.c)

target_include_directories(${project_name} PRIVATE \${CMAKE_SOURCE_DIR}/include)
EOF

echo "Create $project_name c"

cmake -S . -B build
cmake --build build

git init