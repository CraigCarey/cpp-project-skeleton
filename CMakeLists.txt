cmake_minimum_required(VERSION 3.5)
project(cpp-weekly-project)

if (MSVC)
	add_compile_options(/W4)
else()
	add_compile_options(-Wall -Wextra -Wpedantic)
endif()


add_executable(hello_world src/main.cpp)
target_compile_features(hello_world PRIVATE cxx_lambda_init_captures)

enable_testing()
add_executable(tester test/tester.cpp)
add_test(Tester tester)
