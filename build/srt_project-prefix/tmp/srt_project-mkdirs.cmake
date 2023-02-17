# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

file(MAKE_DIRECTORY
  "/home/sten/github/client/build/srt"
  "/home/sten/github/client/build/srt"
  "/home/sten/github/client/build/srt_project-prefix"
  "/home/sten/github/client/build/srt_project-prefix/tmp"
  "/home/sten/github/client/build/srt_project-prefix/src/srt_project-stamp"
  "/home/sten/github/client/build/srt_project-prefix/src"
  "/home/sten/github/client/build/srt_project-prefix/src/srt_project-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "/home/sten/github/client/build/srt_project-prefix/src/srt_project-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "/home/sten/github/client/build/srt_project-prefix/src/srt_project-stamp${cfgdir}") # cfgdir has leading slash
endif()
