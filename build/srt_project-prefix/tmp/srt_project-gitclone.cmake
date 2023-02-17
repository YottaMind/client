# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

if(EXISTS "/home/sten/github/client/build/srt_project-prefix/src/srt_project-stamp/srt_project-gitclone-lastrun.txt" AND EXISTS "/home/sten/github/client/build/srt_project-prefix/src/srt_project-stamp/srt_project-gitinfo.txt" AND
  "/home/sten/github/client/build/srt_project-prefix/src/srt_project-stamp/srt_project-gitclone-lastrun.txt" IS_NEWER_THAN "/home/sten/github/client/build/srt_project-prefix/src/srt_project-stamp/srt_project-gitinfo.txt")
  message(STATUS
    "Avoiding repeated git clone, stamp file is up to date: "
    "'/home/sten/github/client/build/srt_project-prefix/src/srt_project-stamp/srt_project-gitclone-lastrun.txt'"
  )
  return()
endif()

execute_process(
  COMMAND ${CMAKE_COMMAND} -E rm -rf "/home/sten/github/client/build/srt"
  RESULT_VARIABLE error_code
)
if(error_code)
  message(FATAL_ERROR "Failed to remove directory: '/home/sten/github/client/build/srt'")
endif()

# try the clone 3 times in case there is an odd git clone issue
set(error_code 1)
set(number_of_tries 0)
while(error_code AND number_of_tries LESS 3)
  execute_process(
    COMMAND "/usr/bin/git" 
            clone --no-checkout --progress --config "advice.detachedHead=false" "https://github.com/Haivision/srt.git" "srt"
    WORKING_DIRECTORY "/home/sten/github/client/build"
    RESULT_VARIABLE error_code
  )
  math(EXPR number_of_tries "${number_of_tries} + 1")
endwhile()
if(number_of_tries GREATER 1)
  message(STATUS "Had to git clone more than once: ${number_of_tries} times.")
endif()
if(error_code)
  message(FATAL_ERROR "Failed to clone repository: 'https://github.com/Haivision/srt.git'")
endif()

execute_process(
  COMMAND "/usr/bin/git" 
          checkout "v1.5.1" --
  WORKING_DIRECTORY "/home/sten/github/client/build/srt"
  RESULT_VARIABLE error_code
)
if(error_code)
  message(FATAL_ERROR "Failed to checkout tag: 'v1.5.1'")
endif()

set(init_submodules TRUE)
if(init_submodules)
  execute_process(
    COMMAND "/usr/bin/git" 
            submodule update --recursive --init 
    WORKING_DIRECTORY "/home/sten/github/client/build/srt"
    RESULT_VARIABLE error_code
  )
endif()
if(error_code)
  message(FATAL_ERROR "Failed to update submodules in: '/home/sten/github/client/build/srt'")
endif()

# Complete success, update the script-last-run stamp file:
#
execute_process(
  COMMAND ${CMAKE_COMMAND} -E copy "/home/sten/github/client/build/srt_project-prefix/src/srt_project-stamp/srt_project-gitinfo.txt" "/home/sten/github/client/build/srt_project-prefix/src/srt_project-stamp/srt_project-gitclone-lastrun.txt"
  RESULT_VARIABLE error_code
)
if(error_code)
  message(FATAL_ERROR "Failed to copy script-last-run stamp file: '/home/sten/github/client/build/srt_project-prefix/src/srt_project-stamp/srt_project-gitclone-lastrun.txt'")
endif()
