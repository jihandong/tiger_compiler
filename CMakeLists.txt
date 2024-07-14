# MIT License Copyright (c) 2024 jhd
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
cmake_minimum_required(VERSION 3.10)
project(TigerCompiler)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# flexc++.
find_program(FLEXCPP NAMES flexc++)
if (NOT FLEXCPP)
    message(FATAL_ERROR "Program flexc++ not found!")
endif ()

add_custom_command(
    OUTPUT ${PROJECT_SOURCE_DIR}/src/frontend/lex.cc
    COMMAND ${FLEXCPP} tiger.lex
    DEPENDS ${PROJECT_SOURCE_DIR}/src/frontend/tiger.lex
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}/src/frontend/
)

# Collect sources.
include_directories(${PROJECT_SOURCE_DIR}/src)
include_directories(${PROJECT_SOURCE_DIR}/src/frontend)

file(GLOB TIGER_SRCS ${PROJECT_SOURCE_DIR}/src/*.cc)

set(TIGER_FRONTEND_SRCS
    ${PROJECT_SOURCE_DIR}/src/frontend/lex.cc
)
set_source_files_properties(${TIGER_FRONTEND_SRCS} GENERATED)

# Make
add_custom_target(frontend DEPENDS ${TIGER_FRONTEND_SRCS})

add_executable(test_lex
    ${PROJECT_SOURCE_DIR}/test/test_lex.cc
    ${TIGER_SRCS}
    ${TIGER_FRONTEND_SRCS}
)
add_dependencies(test_lex frontend)
