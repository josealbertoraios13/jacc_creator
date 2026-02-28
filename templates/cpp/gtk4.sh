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

echo "Do you want to install the GTK4 libraries for cpp? (y/n): "
read answer

if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
    sudo apt update
    sudo apt install -y libgtkmm-4.0-dev
else
    echo "Skipped gtk3 installation."
fi

mkdir -p src include build

cat << EOF > include/application.hpp
#ifndef GTKMM4_APPLICATION_HPP
#define GTKMM4_APPLICATION_HPP

#include <gtkmm/button.h>
#include <gtkmm/box.h>
#include <gtkmm/window.h>

class Application : public Gtk::Window
{
    public:
        Application();
        ~Application() override;

    protected:
        const int MARGIN = 20;

        //Signal handlers:
        void on_button_clicked();

        //Member widgets:
        Gtk::Button m_button;
        Gtk::Box m_box;

};
#endif
EOF

cat << EOF > src/application.cpp
#include "application.hpp"
#include <iostream>

Application::Application() : m_button("Hello World"), m_box(Gtk::Orientation::VERTICAL)   // creates a new button with label "Hello World".
{
  // Sets the margin around the box.
  m_box.set_margin(MARGIN);

  // When the button receives the "clicked" signal, it will call the
  // on_button_clicked() method defined below.
  m_button.signal_clicked().connect(sigc::mem_fun(*this,
              &Application::on_button_clicked));

  // This packs the button into the Window (a container).
  m_box.append(m_button);

  set_child(m_box);
}

Application::~Application() = default;

void Application::on_button_clicked()
{
  std::cout << "Hello World" << std::endl;
}
EOF

cat << EOF > src/main.cpp
#include "application.hpp"
#include <gtkmm/application.h>

int main(int argc, char* argv[])
{
  auto app = Gtk::Application::create("org.gtkmm.example");

  //Shows the window and returns when it is closed.
  return app->make_window_and_run<Application>(argc, argv);
}
EOF

project_name="my_project_gtk4"

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

pkg_check_modules(GTKMM REQUIRED IMPORTED_TARGET gtkmm-4.0)

add_executable(${project_name} 
    src/main.cpp 
    src/application.cpp)

target_include_directories(${project_name} PRIVATE \${CMAKE_SOURCE_DIR}/include)

target_link_libraries(${project_name} PRIVATE PkgConfig::GTKMM)
EOF

cmake -S . -B build
cmake --build build

git init