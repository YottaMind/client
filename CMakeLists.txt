cmake_minimum_required(VERSION 3.20)

project(
srt-test
C
CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

find_package(Threads REQUIRED)

if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
    set(OPENSSL_ROOT_DIR /usr/local/opt/openssl)
    set(MACOSX_OPENSSL_PATH "-DOPENSSL_ROOT_DIR=/usr/local/opt/openssl")
endif()
find_package(OpenSSL REQUIRED)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)

include(ExternalProject)
ExternalProject_Add(srt_project
        GIT_REPOSITORY https://github.com/Haivision/srt.git
        GIT_TAG v1.5.1
        SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/srt
        BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/srt
        BUILD_COMMAND cmake --build ${CMAKE_CURRENT_BINARY_DIR}/srt --target srt_static
        CMAKE_ARGS -DCMAKE_POSITION_INDEPENDENT_CODE=ON ${MACOSX_OPENSSL_PATH}
        GIT_PROGRESS 1
        STEP_TARGETS build
        EXCLUDE_FROM_ALL TRUE
        INSTALL_COMMAND ""
        )

add_library(srt STATIC IMPORTED)
set_property(TARGET srt PROPERTY IMPORTED_LOCATION ${CMAKE_CURRENT_BINARY_DIR}/srt/libsrt.a)
add_dependencies(srt srt_project)

include_directories(${CMAKE_CURRENT_BINARY_DIR}/srt/)
include_directories(${CMAKE_CURRENT_BINARY_DIR}/srt/common)

find_package(PkgConfig REQUIRED)
pkg_check_modules(LIBAV REQUIRED IMPORTED_TARGET
    libavdevice
    libavfilter
    libavformat
    libavcodec
    libswresample
    libswscale
    libavutil
)

add_executable(srt-test-client client.cpp)
target_compile_options(srt-test-client PRIVATE -Wall -Wextra -pedantic)

target_link_libraries(srt-test-client srt ${OPENSSL_LIBRARIES} Threads::Threads PkgConfig::LIBAV)





        
        
        