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
target_link_libraries(tou_target_name PRIVATE ${CPPMODULE_LINK_ALL_LIBRARIES})
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

target_link_libraries(test_top PRIVATE ${CPPMODULE_LINK_ALL_LIBRARIES})
# or
# target_link_libraries(test_top PRIVATE ${CPPMODULE_LINK_LIBRARIES_JSON} ${CPPMODULE_LINK_LIBRARIES_CPPPINYIN})
```

# 启用的库宏

| 模块名           | 目录         | 宏                                                                                                                                                                                                                                                                                                                                                                                                                                       | 维护仓库                                      | 原始仓库                                    |
|---------------|------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------|-----------------------------------------|
| nlohmann/json | json       | CPPMODULE_JSON                                                                                                                                                                                                                                                                                                                                                                                                                          | https://github.com/huiyicc/json           | https://github.com/nlohmann/json        |
| cpp-pinyin    | cpp-pinyin | CPPMODULE_CPPPINYIN                                                                                                                                                                                                                                                                                                                                                                                                                     | https://github.com/Huiyicc/cpp-pinyin.git | https://github.com/wolfgitpr/cpp-pinyin |
| boost-cmake   | boost      | CPPMODULE_BOOSTCMAKE<br/>使用`CPPMODULE_BOOSTCMAKE_ENABLE_ALL`时默认链接所有库<br/>或者单独使用`CPPMODULE_BOOSTCMAKE_ENABLE_SERIALIZATION`启用`SERIALIZATION`<br/>相似的还有`CPPMODULE_BOOSTCMAKE_ENABLE_FIBER`和`CPPMODULE_BOOSTCMAKE_ENABLE_LOCALE`<br/>如果使用`CPPMODULE_BOOSTCMAKE_ENABLE_ALL`但又想单独禁用某个模块,将ENABLE换成DISABLE<br/>`CPPMODULE_BOOSTCMAKE_DISABLE_SERIALIZATION`<br/>`CPPMODULE_BOOSTCMAKE_DISABLE_FIBER`<br/>`CPPMODULE_BOOSTCMAKE_DISABLE_LOCALE` | https://github.com/OpenHYGUI/boost-cmake  | -                                       |
