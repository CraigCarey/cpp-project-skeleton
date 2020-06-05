cmake_minimum_required(VERSION 3.12)

project(cpp-project-skeleton)

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

add_executable(hello_world src/main.cpp)
target_compile_features(hello_world PRIVATE cxx_lambda_init_captures)

add_executable(md5 src/md5.cpp)
target_link_libraries(md5 ${CONAN_LIBS})

enable_testing()
add_executable(poco_tester test/poco_tester.cpp)
target_link_libraries(poco_tester ${CONAN_LIBS})
add_test(Tester bin/poco_tester)
