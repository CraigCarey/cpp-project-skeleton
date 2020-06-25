#!/usr/bin/env bash

set -eux

readonly SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
pushd "$SCRIPT_DIR" > /dev/null

readonly OPENCV_VERSION="4.3.0"
readonly CUDA_ARCH_BIN="30 35 37 50 52 60 61 70"
readonly CUDA_ARCH_PTX="70"

if [[ ! -f "opencv_contrib-${OPENCV_VERSION}.tar.gz" ]]; then
  axel "https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.tar.gz"
fi
tar xf "opencv_contrib-${OPENCV_VERSION}.tar.gz"
pushd "opencv_contrib-$OPENCV_VERSION"
popd

if [[ ! -f "opencv-${OPENCV_VERSION}.tar.gz" ]]; then
  axel "https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.tar.gz"
fi
tar xf "opencv-${OPENCV_VERSION}.tar.gz"
pushd "opencv-$OPENCV_VERSION"
mkdir -p build && pushd build
cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SHARED_LIBS=ON \
    -DCMAKE_INSTALL_PREFIX="/usr/local" \
    -DWITH_CUDA=ON \
    -DWITH_CUBLAS=ON \
    -DCUDA_FAST_MATH=ON \
    -DWITH_CUFFT=OFF \
    -DCUDA_ARCH_BIN="${CUDA_ARCH_BIN}" \
    -DCUDA_ARCH_PTX="${CUDA_ARCH_PTX}" \
    -DWITH_JPEG=ON \
    -DBUILD_JPEG=ON \
    -DWITH_PNG=ON \
    -DBUILD_PNG=ON \
    -DENABLE_PRECOMPILED_HEADERS=ON \
    -DBUILD_TESTS=OFF \
    -DBUILD_PERF_TESTS=OFF \
    -DBUILD_EXAMPLES=OFF \
    -DBUILD_DOCS=OFF \
    -DWITH_FFMPEG=ON \
    -DWITH_GTK2=ON \
    -DWITH_OPENCL=ON \
    -DWITH_OPENGL=ON \
    -DWITH_QT=OFF \
    -DWITH_V4L=ON \
    -DWITH_JASPER=OFF \
    -DWITH_VTK=OFF \
    -DWITH_1394=OFF \
    -DWITH_TIFF=ON \
    -DBUILD_TIFF=ON \
    -DWITH_OPENEXR=OFF \
    -DWITH_IPP=OFF \
    -DWITH_TBB=ON \
    -DWITH_GSTREAMER=OFF \
    -DWITH_WEBP=OFF \
    -DBUILD_opencv_superres=OFF \
    -DBUILD_opencv_java=OFF \
    -DBUILD_opencv_python2=ON \
    -DBUILD_opencv_python3=ON \
    -DBUILD_opencv_videostab=OFF \
    -DBUILD_opencv_apps=OFF \
    -DBUILD_opencv_flann=ON \
    -DBUILD_opencv_java_bindings_generator=OFF \
    -DBUILD_opencv_ml=ON \
    -DBUILD_opencv_photo=OFF \
    -DBUILD_opencv_shape=OFF \
    -DBUILD_opencv_xfeatures2d=OFF \
    -DBUILD_opencv_stitching=OFF \
    -DBUILD_opencv_cudafilters=OFF \
    -DBUILD_opencv_cudabgsegm=ON \
    -DBUILD_opencv_cudaoptflow=OFF \
    -DBUILD_opencv_cudalegacy=OFF \
    -DBUILD_opencv_cudastereo=OFF \
    -DBUILD_cudaobjdetect=OFF \
    -DBUILD_opencv_objdetect=ON \
    -DBUILD_opencv_cudawarping=ON \
    -DBUILD_opencv_cudaarithm=OFF \
    -DBUILD_opencv_cudev=ON \
    -DOPENCV_GENERATE_PKGCONFIG=YES \
    -DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-${OPENCV_VERSION}/modules/ \
    -DCUDA_NVCC_FLAGS="-O3" ..

make -j $(nproc)
sudo make install
sudo ldconfig
