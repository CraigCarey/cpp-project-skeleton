cmake_minimum_required(VERSION 3.12)
project(skeleton-consumer VERSION 1.0 LANGUAGES CXX)

add_executable(skeletonconsumer main.cpp)
target_compile_features(skeletonconsumer PRIVATE cxx_lambda_init_captures)

find_package(Skeleton 1.0 REQUIRED)
#target_link_libraries(skeletonconsumer Skeleton::Skeleton) # TODO: export poco from libskeleton
