# based on DoQtMess.cmake from https://github.com/siavashk/qt5-static-hello-world
# fill QT_LIBRARIES with all static library from

if(STATIC_TARGET_IS_WINDOWS)
    set(_DEBUG_SUFFIX d)
elseif(STATIC_TARGET_IS_IOS OR STATIC_TARGET_IS_MAC)
    set(_DEBUG_SUFFIX _debug)
else()
    set(_DEBUG_SUFFIX)
endif()
#message("_DEBUG_SUFFIX: ${_DEBUG_SUFFIX}")

get_filename_component(_QT5_INSTALL_PREFIX "${Qt5_DIR}/../../../" ABSOLUTE)
set(_LIBS_BASE_DIR "${_QT5_INSTALL_PREFIX}/lib")
#message("_LIBS_BASE_DIR: ${_LIBS_BASE_DIR}")

# Let's not be picky, just throw all the available static libraries at the linker
# and let it figure out which ones are actually needed.
# A 'foreach' is used because 'target_link_libraries' doesn't handle
# lists correctly (the ; messes it up and nothing actually gets linked against)
file(GLOB_RECURSE _QT_LIBS "${_LIBS_BASE_DIR}/*${CMAKE_STATIC_LIBRARY_SUFFIX}")
foreach(_QT_LIB ${_QT_LIBS})
    string(REGEX MATCH ".*${_DEBUG_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}$" _IS_DEBUG_LIB ${_QT_LIB})
    string(REGEX MATCH ".*_iphonesimulator${_DEBUG_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}$" _IS_DEBUG_SIM_LIB ${_QT_LIB})
    string(REGEX MATCH ".*_iphonesimulator${CMAKE_STATIC_LIBRARY_SUFFIX}$" _IS_SIM_LIB ${_QT_LIB})
    string(REGEX MATCH ".*Qt5Bootstrap.*" _IS_BOOTSTRAP ${_QT_LIB})
    string(REGEX MATCH ".*Qt5QmlDevTools.*" _IS_DEVTOOLS ${_QT_LIB})

    if(NOT _IS_BOOTSTRAP AND NOT _IS_DEVTOOLS AND NOT _IS_DEBUG_SIM_LIB AND NOT _IS_SIM_LIB)
        if(_IS_DEBUG_LIB OR NOT _DEBUG_SUFFIX)
            set(QT_EXTRA_LIBS ${QT_EXTRA_LIBS} debug "${_QT_LIB}")
        endif()
        if(NOT _IS_DEBUG_LIB OR NOT _DEBUG_SUFFIX)
            set(QT_EXTRA_LIBS ${QT_EXTRA_LIBS} optimized "${_QT_LIB}")
        endif()
    endif()
endforeach()
#message("QT_EXTRA_LIBS: ${QT_EXTRA_LIBS}")

set(_QML_BASE_DIR "${_QT5_INSTALL_PREFIX}/qml")
file(GLOB_RECURSE _QML_PLUGINS "${_QML_BASE_DIR}/*${CMAKE_STATIC_LIBRARY_SUFFIX}")
foreach(_QML_PLUGIN ${_QML_PLUGINS})
    string(REGEX MATCH ".*${_DEBUG_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}$" _IS_DEBUG_LIB ${_QML_PLUGIN})
    string(REGEX MATCH ".*_iphonesimulator${_DEBUG_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}$" _IS_DEBUG_SIM_LIB ${_QML_PLUGIN})
    string(REGEX MATCH ".*_iphonesimulator${CMAKE_STATIC_LIBRARY_SUFFIX}$" _IS_SIM_LIB ${_QML_PLUGIN})

    if(NOT _IS_DEBUG_SIM_LIB AND NOT _IS_SIM_LIB)
        if(_IS_DEBUG_LIB OR NOT _DEBUG_SUFFIX)
            set(QT_EXTRA_LIBS ${QT_EXTRA_LIBS} debug "${_QML_PLUGIN}")
        endif()
        if(NOT _IS_DEBUG_LIB OR NOT _DEBUG_SUFFIX)
            set(QT_EXTRA_LIBS ${QT_EXTRA_LIBS} optimized "${_QML_PLUGIN}")
        endif()
    endif()
endforeach()
#message("QML QT_EXTRA_LIBS: ${QT_EXTRA_LIBS}")

set(_PLUGINS_BASE_DIR "${_QT5_INSTALL_PREFIX}/plugins")
file(GLOB_RECURSE _QT_PLUGINS "${_PLUGINS_BASE_DIR}/*${CMAKE_STATIC_LIBRARY_SUFFIX}")
foreach(_QT_PLUGIN ${_QT_PLUGINS})
    string(REGEX MATCH ".*${_DEBUG_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}$" _IS_DEBUG_LIB ${_QT_PLUGIN})
    string(REGEX MATCH ".*_iphonesimulator${_DEBUG_SUFFIX}${CMAKE_STATIC_LIBRARY_SUFFIX}$" _IS_DEBUG_SIM_LIB ${_QT_PLUGIN})
    string(REGEX MATCH ".*_iphonesimulator${CMAKE_STATIC_LIBRARY_SUFFIX}$" _IS_SIM_LIB ${_QT_PLUGIN})

    if(NOT _IS_DEBUG_SIM_LIB AND NOT _IS_SIM_LIB)
        if(_IS_DEBUG_LIB OR NOT _DEBUG_SUFFIX)
            set(QT_EXTRA_LIBS ${QT_EXTRA_LIBS} debug "${_QT_PLUGIN}")
        endif()
        if(NOT _IS_DEBUG_LIB OR NOT _DEBUG_SUFFIX)
            set(QT_EXTRA_LIBS ${QT_EXTRA_LIBS} optimized "${_QT_PLUGIN}")
        endif()
    endif()
endforeach()

set(QT_EXTRA_LIBS ${QT_EXTRA_LIBS}
    "-framework Foundation -framework CoreWLAN -framework ApplicationServices -framework AGL \
-framework DiskArbitration -framework CoreServices -framework Cocoa -framework IOKit -framework SystemConfiguration \
-framework OpenGL -framework Carbon -framework CoreText -framework QuartzCore -framework CoreGraphics \
-framework CoreVideo -framework CoreMedia -framework AVFoundation -framework CoreFoundation -framework AudioUnit \
-framework AppKit -framework AudioToolbox -framework IOSurface -framework Metal \
-framework Security -framework CFNetwork -framework CoreBluetooth -framework IOBluetooth -framework CoreLocation \
-lz -lcups")

# static linking
set(QT_LIBRARIES ${QT_LIBRARIES} ${QT_EXTRA_LIBS})
if(CMAKE_COMPILER_IS_GNUCC OR CMAKE_COMPILER_IS_GNUCXX OR (CMAKE_CXX_COMPILER_ID STREQUAL "Clang" AND NOT APPLE))
    set(${QT_LIBRARIES} -Wl,--start-group ${${QT_LIBRARIES}} -Wl,--end-group)
endif()