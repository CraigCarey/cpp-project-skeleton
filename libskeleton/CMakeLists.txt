cmake_minimum_required(VERSION 3.12)
project(libskeleton VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)

if(EXISTS ${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
    include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
    conan_basic_setup()
else()
    message(WARNING "conanbuildinfo.cmake doesn't exist, you need to run `conan install ..`")
endif()

if (MSVC)
	add_compile_options(/W4)
else()
	add_compile_options(-Wall -Wextra -Wpedantic)
endif()

add_executable(md5 src/skeleton.cpp include/skeleton.hpp)
target_link_libraries(md5 ${CONAN_LIBS})

set(LIB_SKELETON "skeleton")
add_library(${LIB_SKELETON} src/skeleton.cpp)
target_link_libraries(${LIB_SKELETON} ${CONAN_LIBS})

message("CMAKE_CURRENT_BINARY_DIR" ${CMAKE_CURRENT_BINARY_DIR})

enable_testing()
add_executable(skeleton_tester test/skeleton_tester.cpp)
target_link_libraries(skeleton_tester ${LIB_SKELETON})
add_test(SkeletonTester ${CMAKE_CURRENT_BINARY_DIR}/bin/skeleton_tester)

add_executable(poco_tester test/poco_tester.cpp)
target_link_libraries(poco_tester ${CONAN_LIBS})
add_test(PocoTester ${CMAKE_CURRENT_BINARY_DIR}/bin/poco_tester)

