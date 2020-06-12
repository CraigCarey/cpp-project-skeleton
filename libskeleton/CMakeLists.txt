cmake_minimum_required(VERSION 3.12 FATAL_ERROR)
project(libskeleton VERSION 1.0 LANGUAGES CXX)

# Using the "cmake_find_package" generator
set(CMAKE_MODULE_PATH ${CMAKE_BINARY_DIR} ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH ${CMAKE_BINARY_DIR} ${CMAKE_PREFIX_PATH})

find_package(GTest REQUIRED)
find_package(Poco REQUIRED)

set(LIB_SKELETON "skeleton")
add_library(${LIB_SKELETON} src/skeleton.cpp)

# Add an alias so that library can be used inside the build tree, e.g. when testing
add_library(Skeleton::Skeleton ALIAS ${LIB_SKELETON})

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

target_compile_options(${LIB_SKELETON}
	PRIVATE
		$<$<OR:$<CXX_COMPILER_ID:Clang>,$<CXX_COMPILER_ID:AppleClang>,$<CXX_COMPILER_ID:GNU>>:-Wall -Wextra -Wpedantic>
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

target_link_libraries(${LIB_SKELETON}
	PUBLIC
		Poco::Poco
)

enable_testing()
add_executable(skeleton_tester test/skeleton_tester.cpp)
target_link_libraries(skeleton_tester PRIVATE ${LIB_SKELETON} GTest::GTest)
target_include_directories(skeleton_tester PRIVATE ${GTEST_INCLUDE_DIRS})
add_test(SkeletonTester skeleton_tester)

##############################################
# Installation

include(GNUInstallDirs)
set(INSTALL_CONFIGDIR ${CMAKE_INSTALL_LIBDIR}/cmake/Skeleton)

# This is required so that the exported target has the name Skeleton and not skeleton
set_target_properties(skeleton PROPERTIES EXPORT_NAME Skeleton)

install(
    TARGETS skeleton
    EXPORT SkeletonTargets
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

install(DIRECTORY include/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

# Export the targets to a script
install(EXPORT SkeletonTargets
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
	PATH_VARS CMAKE_INSTALL_INCLUDEDIR CMAKE_INSTALL_LIBDIR
)

export(
    EXPORT SkeletonTargets
    FILE ${CMAKE_CURRENT_BINARY_DIR}/SkeletonTargets.cmake
    NAMESPACE Skeleton::
)

# Install the config, configversion and dependency find modules
install(
		FILES
		${CMAKE_CURRENT_BINARY_DIR}/FindPoco.cmake
		${CMAKE_CURRENT_BINARY_DIR}/FindOpenSSL.cmake
		${CMAKE_CURRENT_BINARY_DIR}/SkeletonConfig.cmake
		${CMAKE_CURRENT_BINARY_DIR}/SkeletonConfigVersion.cmake
		DESTINATION ${INSTALL_CONFIGDIR}
)

# Register package in user's package registry
export(PACKAGE Skeleton)
