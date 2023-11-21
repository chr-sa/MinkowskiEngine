# Use use previous versions, modify these variables
# ARG PYTORCH="1.9.0"
# ARG CUDA="11.1"

ARG PYTORCH="2.1.1"
ARG CUDA="12.1"
ARG CUDNN="8"

FROM pytorch/pytorch:${PYTORCH}-cuda${CUDA}-cudnn${CUDNN}-devel

# https://askubuntu.com/questions/909277/avoiding-user-interaction-with-tzdata-when-installing-certbot-in-a-docker-contai
ARG DEBIAN_FRONTEND=noninteractive

# RTX 3070 has 8.6
# RTX 4090 has 8.9
# https://developer.nvidia.com/cuda-gpus

# CUDA 11.8 supports up to 8.9
# https://docs.nvidia.com/cuda/ada-compatibility-guide/index.html#building-applications-using-cuda-toolkit-11-8
ENV TORCH_CUDA_ARCH_LIST="8.6 8.9+PTX"

ENV TORCH_NVCC_FLAGS="-Xfatbin -compress-all"

# Install dependencies
RUN apt-get update
RUN apt-get install -y git ninja-build cmake build-essential libopenblas-dev \
    xterm xauth openssh-server tmux wget mate-desktop-environment-core

RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# For faster build, use more jobs.
ENV MAX_JOBS=4

COPY . /MinkowskiEngine
WORKDIR /MinkowskiEngine
RUN ls
RUN python setup.py install --force_cuda --blas=openblas
