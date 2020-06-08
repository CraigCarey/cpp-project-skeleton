cmake_minimum_required(VERSION 3.12)
project(skeleton-consumer VERSION 1.0 LANGUAGES CXX)

add_executable(skeletonconsumer main.cpp)
target_compile_features(skeletonconsumer PRIVATE cxx_lambda_init_captures)
