# 说明

仅需少量操作即可

# 注意事项

- 编译器至少需要支持c20
- 部分库依赖其他运行时,请注意(例如:tokenizers-cpp需要安装Rust)
- windows msvc 使用 MultiThreadedDLL/MultiThreadedDebugDLL(/MD or /MDd) 运行时

# 下载配置

```shell
# 克隆项目
git clone https://github.com/Huiyicc/CppModels
cd CppModels
# 初始化所有仓库
git submodule update --init
# 当然也可以初始化需要的仓库
git submodule update --init json boost ...
```

设置系统环境变量  `CPPMODULES`为克隆所在的项目地址

```shell
CPPMODULES=<CppModels_path>
```

# cmake使用

```cmake

set(CPPMODULES $ENV{CPPMODULES})

set(CPPMODULE_BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR})
# 需要启用的库
set(CPPMODULE_JSON 1)
set(CPPMODULE_CPPPINYIN 1)

include(${CPPMODULES}/all.cmake)

# ...
target_link_libraries(tou_target_name PRIVATE ${CPPMODULE_LINK_LIBRARIES_ALL})
# 或者你只想链接单个库
# 默认约定
# CPPMODULE_LINK_LIBRARIES_<忽略了 CPPMODULE 前缀的宏>
# target_link_libraries(tou_target_name PRIVATE ${CPPMODULE_LINK_LIBRARIES_JSON} ${CPPMODULE_LINK_LIBRARIES_CPPPINYIN})

```

例如:

```cmake
cmake_minimum_required(VERSION 3.29)
project(test_top)

set(CMAKE_CXX_STANDARD 20)

set(CPPMODULES $ENV{CPPMODULES})

#-------------
set(CPPMODULE_BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR})
# 需要启用的库
set(CPPMODULE_JSON 1)
set(CPPMODULE_CPPPINYIN 1)

include(${CPPMODULES}/all.cmake)
#-------------
add_executable(test_top main.cpp)

target_link_libraries(test_top PRIVATE ${CPPMODULE_LINK_LIBRARIES_ALL})
# or
# target_link_libraries(test_top PRIVATE ${CPPMODULE_LINK_LIBRARIES_JSON} ${CPPMODULE_LINK_LIBRARIES_CPPPINYIN})
```

# 置入的宏

> 以下宏可直接在c++项目内使用

| 宏               | 值 | 备注         |
|-----------------|---|------------|
| \_HOST_APPLE_   | - | 系统为macos   |
| \_HOST_WINDOWS_ | - | 系统为windows |
| \_HOST_LINUX_   | - | 系统为linux   |

# 启用的库宏

| 开源许可证          | 模块名            | 目录             | 库说明                                    | 宏                                                                                                                                                                                                                                                                                                                                         | 备注                                                                                                                                                                                                                                                                                                                                                                                                                  | 维护仓库                                      | 原始仓库                                        |
|----------------|----------------|----------------|----------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------|---------------------------------------------|
| MIT            | nlohmann/json  | json           | 一个流行的仅标头的快速JSON库                       | CPPMODULE_JSON                                                                                                                                                                                                                                                                                                                            | -                                                                                                                                                                                                                                                                                                                                                                                                                   | https://github.com/huiyicc/json           | https://github.com/nlohmann/json            |
| Apache-2.0     | cpp-pinyin     | cpp-pinyin     | 一个轻量级的中文/粤语转拼音库                        | CPPMODULE_CPPPINYIN                                                                                                                                                                                                                                                                                                                       | -                                                                                                                                                                                                                                                                                                                                                                                                                   | https://github.com/Huiyicc/cpp-pinyin.git | https://github.com/wolfgitpr/cpp-pinyin     |
| Boost Software | boost-cmake    | boost          | boost生态库的cmake版本                       | CPPMODULE_BOOSTCMAKE<br/>---<br/>CPPMODULE_BOOSTCMAKE_ENABLE_ALL<br/>---<br/>CPPMODULE_BOOSTCMAKE_ENABLE_SERIALIZATION<br/>CPPMODULE_BOOSTCMAKE_ENABLE_FIBER<br/>CPPMODULE_BOOSTCMAKE_ENABLE_LOCALE<br/>---<br/>CPPMODULE_BOOSTCMAKE_DISABLE_SERIALIZATION<br/>CPPMODULE_BOOSTCMAKE_DISABLE_FIBER<br/>CPPMODULE_BOOSTCMAKE_DISABLE_LOCALE | <br/>使用`CPPMODULE_BOOSTCMAKE_ENABLE_ALL`时默认链接所有库<br/>或者单独使用`CPPMODULE_BOOSTCMAKE_ENABLE_SERIALIZATION`启用`SERIALIZATION`<br/>相似的还有`CPPMODULE_BOOSTCMAKE_ENABLE_FIBER`和`CPPMODULE_BOOSTCMAKE_ENABLE_LOCALE`<br/>如果使用`CPPMODULE_BOOSTCMAKE_ENABLE_ALL`但又想单独禁用某个模块,将ENABLE换成DISABLE<br/>`CPPMODULE_BOOSTCMAKE_DISABLE_SERIALIZATION`<br/>`CPPMODULE_BOOSTCMAKE_DISABLE_FIBER`<br/>`CPPMODULE_BOOSTCMAKE_DISABLE_LOCALE` | https://github.com/OpenHYGUI/boost-cmake  | -                                           |
| Zlib           | SDL            | SDL            | 跨平台的直接媒体层库                             | CPPMODULE_SDL<br/>---<br/>CPPMODULE_SDL_ENABLE_OPENGL                                                                                                                                                                                                                                                                                     | 开启OPENGL: `CPPMODULE_SDL_ENABLE_OPENGL` <br/>注意: 非Windows平台如果需要开启OPENGL加速,则需要确认你已经安装了Opengl开发库                                                                                                                                                                                                                                                                                                                      | -                                         | https://github.com/libsdl-org/SDL           |
| Apache-2.0     | tokenizers-cpp | tokenizers-cpp | tokenizers库的c++版本                      | CPPMODULE_TOKENIZERS                                                                                                                                                                                                                                                                                                                      | 需要安装Rust                                                                                                                                                                                                                                                                                                                                                                                                            | https://github.com/Huiyicc/tokenizers-cpp | https://github.com/mlc-ai/tokenizers-cpp    |
| LGPL-2.1       | SRELL          | SRELL          | 一个支持UTF-8/UTF-16/UTF-32文本的正则模板库(兼容std) | CPPMODULE_SRELL                                                                                                                                                                                                                                                                                                                           | -                                                                                                                                                                                                                                                                                                                                                                                                                   | https://github.com/Huiyicc/SRELL          | https://github.com/ZimProjects/SRELL        |
| BSD-2-Clause   | utfcpp         | utfcpp         | 一个轻量简单的/可移植的处理 Unicode 编码字符串的库         | CPPMODULE_UTFCPP                                                                                                                                                                                                                                                                                                                          | -                                                                                                                                                                                                                                                                                                                                                                                                                   | https://github.com/Huiyicc/utfcpp         | https://github.com/nemtrif/utfcpp           |
| MIT            | cppjieba       | cppjieba       | 知名中文分词库"Jieba"的C++版本                   | CPPMODULE_CPPJIEBA                                                                                                                                                                                                                                                                                                                        | -                                                                                                                                                                                                                                                                                                                                                                                                                   | https://github.com/Huiyicc/cppjieba       | https://github.com/yanyiwu/cppjieba         |
| BSD-2-Clause   | libsamplerate  | libsamplerate  | 一个用于执行音频数据采样率转换的库                      | CPPMODULE_LIBSAMPLERATE                                                                                                                                                                                                                                                                                                                   | -                                                                                                                                                                                                                                                                                                                                                                                                                   | https://github.com/Huiyicc/libsamplerate  | https://github.com/libsndfile/libsamplerate |
| Apache-2.0     | cld2           | cld2-cmake     | 紧凑型语言检测库,用于检测字符串中文本对应语言的概率,支持80 多种语言   | CPPMODULE_CLD2                                                                                                                                                                                                                                                                                                                            | -                                                                                                                                                                                                                                                                                                                                                                                                                   | https://github.com/Huiyicc/cld2-cmake     | https://github.com/CLD2Owners/cld2          |
