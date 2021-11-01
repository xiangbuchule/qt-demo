cmake_minimum_required(VERSION 3.5)

project(qt-demo VERSION 1.0 LANGUAGES CXX)

# 设置include文件（.h文件）的位置
set(IncludePath ${PROJECT_SOURCE_DIR}/include)
# 包含头文件路径
include_directories(
    ${IncludePath}
    ${IncludePath}/pages
)

# 开启qt模块支持
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
# 设置c++编译Debug与Release的编译参数
if(MSVC)
    if("${CMAKE_CXX_FLAGS_DEBUG}" STREQUAL "")
        set(CMAKE_CXX_FLAGS_DEBUG "/Od /Zi /MTd")
    endif()
    if("${CMAKE_CXX_FLAGS_RELEASE}" STREQUAL "")
        set(CMAKE_CXX_FLAGS_RELEASE "/Ox /Wall /MT")
    endif()
endif()
if(GNU)
    if("${CMAKE_CXX_FLAGS_DEBUG}" STREQUAL "")
        set(CMAKE_CXX_FLAGS_DEBUG "-O0 -g3 -ggdb3")
    endif()
    if("${CMAKE_CXX_FLAGS_RELEASE}" STREQUAL "")
        set(CMAKE_CXX_FLAGS_RELEASE "-O3 -Wall")
    endif()
endif()
# 设置编码
set(CompileCode UTF-8)
if(MSVC)
    add_compile_options(/source-charset:${CompileCode} /execution-charset:${CompileCode})
endif()
if(GNU)
    add_compile_options(-finput-charset=${CompileCode} -fexec-charset=${CompileCode} -fwide-exec-charset=${CompileCode})
endif()
# 判断命令传入的是否为空，如果为空，默认Debug
if("${CMAKE_BUILD_TYPE}" STREQUAL "")
    set(CMAKE_BUILD_TYPE "Debug")
endif()
# 设置生成路径
if(MSVC)
    set(TargetPath ${PROJECT_SOURCE_DIR}/bin)
else()
    set(TargetPath ${PROJECT_SOURCE_DIR}/bin/${CMAKE_BUILD_TYPE})
endif()
set(EXECUTABLE_OUTPUT_PATH ${TargetPath})

# 关联qt库
find_package(QT NAMES Qt6 Qt5 COMPONENTS Widgets LinguistTools REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Widgets LinguistTools REQUIRED)

# 设置翻译文件位置
file(GLOB TS_FILES "translations/*.ts")

# 设置源文件
file(GLOB PROJECT_SOURCES
    "src/*.cpp"
    "src/pages/*.cpp"
    "src/pages/*.ui"
    "include/*.h"
    "include/pages/*.h"
    "translations/*.ts"
)

# 创建应用程序与.ui文件生成对应的.h文件
if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_executable(qt-demo
        MANUAL_FINALIZATION
        ${PROJECT_SOURCES}
    )
# Define target properties for Android with Qt 6 as:
#    set_property(TARGET qt-demo APPEND PROPERTY QT_ANDROID_PACKAGE_SOURCE_DIR
#                 ${CMAKE_CURRENT_SOURCE_DIR}/android)
# For more information, see https://doc.qt.io/qt-6/qt-add-executable.html#target-creation

    qt_create_translation(QM_FILES ${CMAKE_SOURCE_DIR} ${TS_FILES})
else()
    if(ANDROID)
        add_library(qt-demo SHARED
            ${PROJECT_SOURCES}
        )
# Define properties for Android with Qt 5 after find_package() calls as:
#    set(ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")
    else()
        add_executable(qt-demo
            ${PROJECT_SOURCES}
        )
    endif()

    qt5_create_translation(QM_FILES ${CMAKE_SOURCE_DIR} ${TS_FILES})
endif()

# 链接qt库
target_link_libraries(qt-demo PRIVATE Qt${QT_VERSION_MAJOR}::Widgets)

# 设置编译属性
set_target_properties(qt-demo PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER fate.saber.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
)

if(QT_VERSION_MAJOR EQUAL 6)
    qt_finalize_executable(qt-demo)
endif()
