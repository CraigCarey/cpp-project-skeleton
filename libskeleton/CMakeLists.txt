cmake_minimum_required(VERSION 3.12)
project(libskeleton VERSION 1.0 LANGUAGES CXX)

if(EXISTS ${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
    include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
    conan_basic_setup(TARGETS)
else()
    message(WARNING "conanbuildinfo.cmake doesn't exist, you need to run `conan install ..`")
endif()

# Conan generates FindPackage.cmake files here
list(INSERT CMAKE_MODULE_PATH 0 ${CMAKE_CURRENT_BINARY_DIR})

if (MSVC)
	add_compile_options(/W4)
else()
	add_compile_options(-Wall -Wextra -Wpedantic)
endif()

find_package(GTest REQUIRED)
find_package(Poco REQUIRED)

set(LIB_SKELETON "skeleton")
add_library(${LIB_SKELETON} src/skeleton.cpp)

# Add an alias so that library can be used inside the build tree, e.g. when testing
add_library(Skeleton::skeleton ALIAS ${LIB_SKELETON})

# Add directories to the target
# PRIVATE and PUBLIC items will populate the INCLUDE_DIRECTORIES property of target
# PUBLIC and INTERFACE items will populate the INTERFACE_INCLUDE_DIRECTORIES property of target
target_include_directories(${LIB_SKELETON}
    PUBLIC
        $<INSTALL_INTERFACE:include>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/src
)

# Add sources to the library
# Header files are added only so that they appear in IDEs such as Visual Studio etc
# For INTERFACE libraries (header only) this is the only way to make the header
# files appear in the project in IDEs such as Visual Studio
target_sources(${LIB_SKELETON}
    PRIVATE
        ${src_files}
        ${header_files}
)

# TODO: works in Linux, not in Windows?
# LINK : fatal error LNK1104: cannot open file 'PocoFoundation.lib' [C:\...\skeleton_tester.vcxproj]
target_link_libraries(${LIB_SKELETON} PRIVATE ${Poco_LIBS})
target_include_directories(${LIB_SKELETON} PRIVATE ${Poco_INCLUDE_DIRS})

# TODO: Allows skeleton_tester to build in Windows, but breaks skeletonconsumer in Win & Linux
# Target "skeletonconsumer" links to target "CONAN_PKG::poco" but the target#
#  was not found.  Perhaps a find_package() call is missing for an IMPORTED#
#  target, or an ALIAS target is missing?
#target_link_libraries(${LIB_SKELETON} PRIVATE CONAN_PKG::poco)

enable_testing()
add_executable(skeleton_tester test/skeleton_tester.cpp)
target_link_libraries(skeleton_tester PRIVATE ${LIB_SKELETON} CONAN_PKG::poco CONAN_PKG::gtest)
target_include_directories(skeleton_tester PRIVATE ${GTEST_INCLUDE_DIRS})
add_test(SkeletonTester ${CMAKE_CURRENT_BINARY_DIR}/bin/skeleton_tester)

##############################################
# Installation

include(GNUInstallDirs)
set(INSTALL_CONFIGDIR ${CMAKE_INSTALL_LIBDIR}/cmake/Skeleton)

install(
    TARGETS skeleton
    EXPORT skeleton-targets
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

# This is required so that the exported target has the name Skeleton and not skeleton
set_target_properties(skeleton PROPERTIES EXPORT_NAME Skeleton)

install(DIRECTORY include/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# Export the targets to a script
install(EXPORT skeleton-targets
    FILE
        SkeletonTargets.cmake
    NAMESPACE
        Skeleton::
    DESTINATION
        ${INSTALL_CONFIGDIR}
)

# Create a ConfigVersion.cmake file
include(CMakePackageConfigHelpers)
write_basic_package_version_file(
    ${CMAKE_CURRENT_BINARY_DIR}/SkeletonConfigVersion.cmake
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY AnyNewerVersion
)

configure_package_config_file(
    ${CMAKE_CURRENT_LIST_DIR}/cmake/SkeletonConfig.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/SkeletonConfig.cmake
    INSTALL_DESTINATION ${INSTALL_CONFIGDIR}
)

# Install the config, configversion and dependency find modules
install(
    FILES
    ${CMAKE_CURRENT_BINARY_DIR}/FindPoco.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/SkeletonConfig.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/SkeletonConfigVersion.cmake
    DESTINATION ${INSTALL_CONFIGDIR}
)

export(
    EXPORT skeleton-targets
    FILE ${CMAKE_CURRENT_BINARY_DIR}/SkeletonTargets.cmake
    NAMESPACE Skeleton::
)

# Register package in user's package registry
export(PACKAGE Skeleton)
