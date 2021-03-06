# CPP Skeleton Project
[![Gitpod ready-to-code](https://img.shields.io/badge/Gitpod-ready--to--code-blue?logo=gitpod)](https://gitpod.io/#https://github.com/CraigCarey/cpp-project-skeleton)
[![Build Status](https://travis-ci.org/CraigANV/cpp-project-skeleton.svg?branch=master)](https://travis-ci.org/CraigANV/cpp-project-skeleton)
[![Build status](https://ci.appveyor.com/api/projects/status/github/CraigANV/cpp-project-skeleton?svg=true)](https://ci.appveyor.com/project/CraigANV/cpp-project-skeleton/branch/master)

A basic project outline with some helpful tooling:
- Travis (Linux) CI
- Appveyor (Windows) CI
- Conan package management
- CTest
- GTest

## TODO
- [ ] DEB packaging
- [ ] Upload Skeleton Conan package to personal artifactory
- [ ] Packaging Pre-built Binaries and pushing to personal artifactory 
- [ ] MacOS CI
- [ ] Static analysis reports - CXX_CLANG_TIDY & CXX_CPPLINT?
- [ ] Test coverage reports
- [ ] Integrate sanitizers
- [ ] Integrate include-what-you-use (or similar) - CXX_INCLUDE_WHAT_YOU_USE / LINK_WHAT_YOU_USE?
- [ ] Integrate Sonarqube (or similar)

### Conan Setup

#### Installation
```bash
pip install conan

# Required for OpenCV sub deps 
# TODO: unless we add libselinux/2.9 to the conanfile, is this a bug worth reporting?
conan remote add bincrafters https://api.bintray.com/conan/bincrafters/public-conan
```

If you are using GCC compiler >= 5.1, Conan will set the compiler.libcxx to the old ABI for backwards compatibility. You can change this with the following commands:
```bash
conan profile new default --detect  # Generates default profile detecting GCC and sets old ABI
conan profile update settings.compiler.libcxx=libstdc++11 default  # Sets libcxx to C++11 ABI
```

Depending on your compiler, getting packages from my personal artifactory may be a lot faster
```bash
# View my artifactory @ https://bintray.com/craiganv/cpp-skeleton-repo
conan remote add artifactory https://api.bintray.com/conan/craiganv/cpp-skeleton-repo
conan remote list
conan install .. -r=artifactory
```

Uploading built packages to my personal artifactory
```bash
conan user -p <API key> -r artifactory craiganv
conan upload "*" -r artifactory --all --confirm
```

### Docker Setup

```bash
docker build -t skeleton .
docker-compose up -d
ssh root@localhost -p 7776 # pw is `root`
cd workspace
./build.sh docker
``` 

### Building, Testing and Installing libskeleton

#### Installing Conan packages
```bash
cd libskeleton
mkdir build && cd build
conan install ../conan/ --build missing -pr=../conan/profiles/gcc

# alternatively...
conan install . -s build_type=Debug --install-folder=cmake-build-debug --build missing
conan install . -s build_type=Release --install-folder=cmake-build-release --build missing
```

#### Building libskeleton
```bash
# Linux & MacOS
cmake .. -DCMAKE_BUILD_TYPE=Debug -DUSE_CONAN_PACKAGE=True
cmake --build . --parallel 2

# Windows
cmake .. -DCMAKE_BUILD_TYPE=Debug -G "Visual Studio 16" -DUSE_CONAN_PACKAGE=True
cmake --build . --config Release --parallel 2
```

#### Testing libskeleton
```bash
ctest --parallel 2
```

#### Installing libskeleton
```bash
sudo cmake --install .

# Uninstall
sudo xargs rm < install_manifest.txt
```

#### Building the consumer app against installed libskeleton
```bash
cd consumer
mkdir build && cd build

# Linux & MacOS
cmake .. -DCMAKE_BUILD_TYPE=Debug -DUSE_CONAN_PACKAGE=True
cmake --build . --parallel 2

# Windows
cmake .. -DBUILD_TEST=TRUE -DCMAKE_BUILD_TYPE=Release -G "Visual Studio 16"
cmake --build . --config Release --parallel 2
```
