cmake_minimum_required(VERSION 3.14)
project(qtminstatic)

set(CMAKE_CXX_STANDARD 14)

# static QT
set(CMAKE_PREFIX_PATH ~/work/Qt/5.12.4/static_64)

# Find the QtWidgets library
find_package(Qt5 COMPONENTS Widgets REQUIRED Gui REQUIRED)

add_executable(qtminstatic MACOSX_BUNDLE main.cpp )

foreach(plugin ${Qt5Gui_PLUGINS})
    get_target_property(_loc ${plugin} LOCATION)
    message("Gui Plugin ${plugin} is at location ${_loc}")
endforeach()

set(STATIC_TARGET_IS_MAC)
include("DoQtStatic.cmake")

message("QT libs: ${QT_LIBRARIES}")
# Add the Qt5 Widgets for linking
target_link_libraries(qtminstatic Qt5::Widgets ${QT_LIBRARIES})
