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

echo "Do you want to install the GTK3 libraries for cpp? (y/n): "
read answer

if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
    sudo apt update
    sudo apt install -y libgtkmm-3.0-dev
else
    echo "Skipped gtk3 installation."
fi

mkdir -p src include build

cat << EOF > include/application.hpp
#ifndef GTKMM3_APPLICATION_HPP
#define GTKMM3_APPLICATION_HPP

#include <gtkmm/window.h>
#include <gtkmm/buttonbox.h>
#include <gtkmm/button.h>

class Application : public Gtk::Window
{
    public:
        Application();
        ~Application() override;

    protected:
        // Signal handlers:
        void on_button_clicked();

        // Member widgets:
        Gtk::Button m_button;
        Gtk::ButtonBox m_button_box;
};
#endif
EOF

cat << EOF > src/main.cpp
#include "application.hpp"
#include <gtkmm/application.h>

int main(int argc, char* argv[]){
    auto app = Gtk::Application::create("org.gtkmm.example");

    Application win;
    //Shows the window and returns when it is closed.
    return app->run(win);
}
EOF

cat << EOF > src/application.cpp
#include "application.hpp"
#include <iostream>

Application::Application() : m_button("Hello World")   // creates a new button with label "Hello World".
{
  // When the button receives the "clicked" signal, it will call the
  // on_button_clicked() method defined below.
  m_button.signal_clicked().connect(sigc::mem_fun(*this,
              &Application::on_button_clicked));

  // This packs the button into the Window (a container).
  m_button_box.add(m_button);
  add(m_button_box);
  show_all_children();
}

Application::~Application() = default;

void Application::on_button_clicked()
{
    std::cout << "Hello, World!" << std::endl;
}
EOF

project_name="my_project_gtk3"

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

pkg_check_modules(GTKMM REQUIRED IMPORTED_TARGET gtkmm-3.0)

add_executable(${project_name} 
    src/main.cpp 
    src/application.cpp)

target_include_directories(${project_name} PRIVATE \${CMAKE_SOURCE_DIR}/include)

target_link_libraries(${project_name} PRIVATE PkgConfig::GTKMM)
EOF

cmake -S . -B build
cmake --build build