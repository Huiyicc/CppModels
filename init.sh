#!/bin/bash
git clone https://github.com/Huiyicc/cpp-pinyin.git
git clone -b 00bb81de769a80303e607aea149419902230bc4b https://github.com/huiyicc/json
git clone -b 78cc5c173404488d80751af226d1eaf67033bcc4 https://github.com/libsdl-org/SDL
git clone https://github.com/OpenHYGUI/boost-cmake
git clone https://github.com/Huiyicc/tokenizers-cpp
cd tokenizers-cpp
git submodule init
git submodule update
git clone https://github.com/huiyicc/libsndfile
cd libsndfile
git submodule init
git submodule update
git clone https://github.com/huiyicc/SRELL
git clone https://github.com/Huiyicc/utfcpp
git clone https://github.com/Huiyicc/cppjieba
git clone https://github.com/Huiyicc/libsamplerate
