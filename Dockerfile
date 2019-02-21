FROM nvidia/cuda:8.0-devel-ubuntu16.04

RUN apt-get update && apt-get install -y wget
# install CUDA 10.0 in the same container
RUN wget -q https://developer.nvidia.com/compute/cuda/10.0/Prod/local_installers/cuda_10.0.130_410.48_linux && \
    chmod +x cuda_10.0.130_410.48_linux && \
    ./cuda_10.0.130_410.48_linux --silent --no-opengl-libs --toolkit && \
    rm -f cuda_10.0.130_410.48_linux
