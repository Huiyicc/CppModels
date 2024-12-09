#!/bin/bash
sudo apt install autoconf autogen automake build-essential libasound2-dev \
  libflac-dev libogg-dev libtool libvorbis-dev libopus-dev libmp3lame-dev \
  libmpg123-dev pkg-config python
git clone https://github.com/Huiyicc/cpp-pinyin.git
git clone -b 00bb81de769a80303e607aea149419902230bc4b https://github.com/huiyicc/json
git clone -b 78cc5c173404488d80751af226d1eaf67033bcc4 https://github.com/libsdl-org/SDL
git clone https://github.com/OpenHYGUI/boost-cmake
git clone https://github.com/Huiyicc/tokenizers-cpp
cd tokenizers-cpp
git submodule init
git submodule update
cd ..
git clone https://github.com/huiyicc/libsndfile
cd libsndfile
git submodule init
git submodule update
cd ..
git clone https://github.com/huiyicc/SRELL
git clone https://github.com/Huiyicc/utfcpp
git clone https://github.com/Huiyicc/cppjieba
git clone https://github.com/Huiyicc/libsamplerate
git clone https://github.com/Huiyicc/cld2-cmake
git clone https://github.com/Huiyicc/xtl
git clone https://github.com/Huiyicc/xtensor-blas
git clone https://github.com/Huiyicc/xtensor
git clone https://github.com/Huiyicc/fmt
git clone https://github.com/Huiyicc/gpt_sovits_cpp
