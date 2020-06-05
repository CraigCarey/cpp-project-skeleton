# CPP Skeleton Project

[![Build Status](https://travis-ci.org/CraigANV/cpp-project-skeleton.svg?branch=master)](https://travis-ci.org/CraigANV/cpp-project-skeleton)
[![Build status](https://ci.appveyor.com/api/projects/status/github/CraigANV/cpp-project-skeleton?svg=true)](https://ci.appveyor.com/project/CraigANV/cpp-project-skeleton/branch/master)

A basic project outline with some helpful tooling:
- Travis (Linux) CI
- Appveyor (Windows) CI
- Conan package management
- CTest
- GTest

## TODO
- [ ] MacOS CI
- [ ] Test coverage reports
- [ ] Integrate sanitizers
- [ ] Integrate include-what-you-use (or similar)
- [ ] Integrate Sonarqube (or similar)

### Conan Setup

#### Installation
```bash
pip install conan
```

If you are using GCC compiler >= 5.1, Conan will set the compiler.libcxx to the old ABI for backwards compatibility. You can change this with the following commands:
```bash
conan profile new default --detect  # Generates default profile detecting GCC and sets old ABI
conan profile update settings.compiler.libcxx=libstdc++11 default  # Sets libcxx to C++11 ABI
```

```bash
mkdir build && cd build
conan install .. --build missing

# alternatively
conan install . -s build_type=Debug --install-folder=cmake-build-debug --build missing
conan install . -s build_type=Release --install-folder=cmake-build-release --build missing
```

### Building and Testing

```bash
mkdir build && cd build
conan install .. --build missing

# (Linux, mac)
$ cmake .. -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Debug
$ cmake --build .
$ make VERBOSE=1  # alternatively

# (win)
$ cmake .. -G "Visual Studio 16"
$ cmake --build . --config Release

$ ctest
```