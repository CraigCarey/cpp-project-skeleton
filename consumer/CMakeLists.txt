cmake_minimum_required(VERSION 3.12)
project(skeleton-consumer VERSION 1.0 LANGUAGES CXX)

find_package(Skeleton 1.0 REQUIRED)
find_package(Boost COMPONENTS chrono REQUIRED)

add_executable(skeletonconsumer main.cpp)
target_compile_features(skeletonconsumer PRIVATE cxx_lambda_init_captures)
target_link_libraries(skeletonconsumer Skeleton::Skeleton)
