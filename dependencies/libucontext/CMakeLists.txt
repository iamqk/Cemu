cmake_minimum_required (VERSION 3.15)


project("libucontext"
    VERSION "0.1.2"
    DESCRIPTION "Library for tmp correct ucontext function error on apple sillicon"
    HOMEPAGE_URL "https://github.com/MCApollo/libucontext-ios-arm64"
)

list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")

include(GNUInstallDirs)

enable_language(C ASM)
set ( SOURCES 
    makecontext.c
    context.S
)

include_directories(include/ /)
aux_source_directory(src DIR_SOURCE)
set(SRC_FILE_PATH ${DIR_SOURCE})
SET(ASM_OPTIONS "-x assembler-with-cpp")
SET(CMAKE_ASM_FLAGS "${CFLAGS} ${ASM_OPTIONS}" )

add_library(ucontext1 STATIC ${SOURCES})
add_library(libucontext::ucontext1 ALIAS ucontext1)

set_target_properties(ucontext1 PROPERTIES
    MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>"
    VERSION "${PROJECT_VERSION}"
    SOVERSION "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}"
)

target_include_directories(ucontext1
    PUBLIC
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
        $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
)

install(DIRECTORY include/ucontext1/ DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/ucontext1" FILES_MATCHING PATTERN "ucontext*.h")
install(TARGETS ucontext1)

