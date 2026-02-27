# JACC-CREATOR

This shell script for Linux allows you to create pre-configured projects for the C/C++ language and the CMake project compiler.

## Reason

Created by me because I was tired of having to create folders and files to configure a C/C++ project. Yes, I know there are IDEs that solve this problem, but I wanted to do it anyway, haha.

## Installation Guide

1- SSH:
```bash
git clone git@github.com:josealbertoraios13/jacc_creator.git
cd jacc_creator
```
or

1- HTTPS:
```bash
git clone https://github.com/josealbertoraios13/jacc_creator.git
cd jacc_creator
```

2- Make the installation script executable:
```bash
chmod x+ install.sh
```
3- Run the script:
```bash
./install.sh
```
4- Confirm installation:
```bash
jacc --version
```
## Examples

1- Get all available commands with:
```bash
jacc --help
```
2- Base project example:
```bash
jacc create <language('c' or 'cpp')> <Project_type> <project_name Optional>
```
3- Project base file tree
```bash
├── build
│   ├── CMakeCache.txt
│   ├── CMakeFiles
│   │   ├── 3.28.3
│   │   │   ├── CMakeCXXCompiler.cmake
│   │   │   ├── CMakeDetermineCompilerABI_CXX.bin
│   │   │   ├── CMakeSystem.cmake
│   │   │   └── CompilerIdCXX
│   │   │       ├── a.out
│   │   │       ├── CMakeCXXCompilerId.cpp
│   │   │       └── tmp
│   │   ├── cmake.check_cache
│   │   ├── CMakeConfigureLog.yaml
│   │   ├── CMakeDirectoryInformation.cmake
│   │   ├── CMakeScratch
│   │   ├── Makefile2
│   │   ├── Makefile.cmake
│   │   ├── project_name.dir
│   │   │   ├── build.make
│   │   │   ├── cmake_clean.cmake
│   │   │   ├── compiler_depend.make
│   │   │   ├── compiler_depend.ts
│   │   │   ├── DependInfo.cmake
│   │   │   ├── depend.make
│   │   │   ├── flags.make
│   │   │   ├── link.txt
│   │   │   ├── main.cpp.o
│   │   │   ├── main.cpp.o.d
│   │   │   └── progress.make
│   │   ├── pkgRedirects
│   │   ├── progress.marks
│   │   └── TargetDirectories.txt
│   ├── cmake_install.cmake
│   ├── Makefile
│   └── your_project
├── CMakeLists.txt
├── include
├── main.cpp
└── src
```
## Uninstall Guide

1- To uninstall use:
```bash
jacc uninstall

```



