# options:
# CPPMODULE_JSON

function(CHECK_SUB)
  # 获取传入的参数
  set(var_list ${ARGN})

  foreach (var ${var_list})
    # 检查变量是否存在
    if (NOT DEFINED ${var})
      message(FATAL_ERROR "依赖 '${var}' 未引入.\n请在 include(${CPPMODULES}/all.cmake) 前添加 set(${var} 1)")
    endif ()
  endforeach ()

endfunction()

message("===== INCLUDE C++ MODULES BEGIN =====")

set(CPPMODULE_ROOTPATH ${CMAKE_CURRENT_LIST_DIR})

add_definitions(-DCPPMODULE_PROJECT_ROOT_PATH=\"${CMAKE_CURRENT_SOURCE_DIR}\")

message("CPPMODULE_ROOTPATH=${CPPMODULE_ROOTPATH}")

message("Check Variables")
if (CPPMODULE_BINARY_DIR)
  message("CPPMODULE_BINARY_DIR=${CPPMODULE_BINARY_DIR}")
  set(CPPMODULE_BINARY_SUBDIR ${CPPMODULE_BINARY_DIR}/CPPMODULE_BIN)
else ()
  message(FATAL_ERROR "CPPMODULE_BINARY_DIR is not defined. Please define it.
Example:
set(CPPMODULE_BINARY_DIR \${CMAKE_CURRENT_BINARY_DIR})")
endif ()

if (MSVC)
  #  add_compile_options(/source-charset:utf-8 /execution-charset:utf-8)
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /utf-8")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /utf-8")
else ()
  add_compile_options(-finput-charset=UTF-8 -fexec-charset=UTF-8)
endif ()

if (MSVC)

  set(CMAKE_EXE_LINKER_FLAGS_DEBUG "${CMAKE_EXE_LINKER_FLAGS_DEBUG} /NODEFAULTLIB:msvcrt.lib")
  set(CPPMODULE_LINK_LIBRARIES_ALL ${CPPMODULE_LINK_LIBRARIES_ALL} legacy_stdio_definitions.lib)

  #  set(CMAKE_EXE_LINKER_FLAGS_RELEASE "${CMAKE_EXE_LINKER_FLAGS_RELEASE} /NODEFAULTLIB:msvcrt.lib")
endif ()

# =========

set(CPPMODULE_LINK_ALL_LIBRARIES "")
set(CPPMODULE_LINK_SOURCES "")

if (CMAKE_SYSTEM_NAME STREQUAL "Android")
  set(OS_IS_ANDROID TRUE)
  add_definitions(-D_HOST_ANDROID_)
elseif ((CMAKE_HOST_SYSTEM_NAME MATCHES "Darwin"))
  set(OS_IS_APPLE TRUE)
  add_definitions(-D_HOST_APPLE_)
elseif (CMAKE_HOST_WIN32)
  set(OS_IS_WINDOWS TRUE)
  add_definitions(-D_HOST_WINDOWS_)
  if ()
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
  endif ()
elseif (CMAKE_HOST_UNIX)
  set(OS_IS_LINUX TRUE)
  add_definitions(-D_HOST_LINUX_)
else ()
  message(FATAL_ERROR "The platform is not currently supported")
endif ()

# nlohmann json
if (CPPMODULE_JSON)
  message("[MIT] nlohmann/json: ON | By: https://github.com/huiyicc/json")
  include(${CPPMODULES}/scripts/JSON.cmake)
else ()
  message("[MIT] nlohmann/json: OFF | By: https://github.com/huiyicc/json")
endif ()

# cpp-pinyin
if (CPPMODULE_CPPPINYIN)
  message("[Apache-2.0] cpp-pinyin: ON | https://github.com/Huiyicc/cpp-pinyin.git")
  include(${CPPMODULES}/scripts/cpp-pinyin.cmake)
else ()
  message("[Apache-2.0] cpp-pinyin: OFF | https://github.com/Huiyicc/cpp-pinyin.git")
endif ()


# boost-cmake
if (CPPMODULE_BOOSTCMAKE)
  message("[Boost Software] boost-cmake: ON | https://github.com/OpenHYGUI/boost-cmake")
  include(${CPPMODULES}/scripts/boost-cmake.cmake)
else ()
  message("[Boost Software] boost-cmake: OFF | https://github.com/OpenHYGUI/boost-cmake")
endif ()


# SDL
if (CPPMODULE_SDL)
  message("[Zlib] SDL: ON | https://github.com/libsdl-org/SDL")
  include(${CPPMODULES}/scripts/SDL.cmake)
else ()
  message("[Zlib] SDL: OFF | https://github.com/libsdl-org/SDL")
endif ()

# tokenizers-cpp
if (CPPMODULE_TOKENIZERS)
  message("[Apache-2.0] tokenizers-cpp: ON | By: https://github.com/Huiyicc/tokenizers-cpp")
  include(${CPPMODULES}/scripts/tokenizers-cpp.cmake)
else ()
  message("[Apache-2.0] tokenizers-cpp: OFF | By: https://github.com/Huiyicc/tokenizers-cpp")
endif ()

# libsndfile
if (CPPMODULE_LIBSNDFILE)
  message("[LGPL-2.1] libsndfile: ON | By: https://github.com/Huiyicc/libsndfile")
  include(${CPPMODULES}/scripts/libsndfile.cmake)
else ()
  message("[LGPL-2.1] libsndfile: OFF | By: https://github.com/Huiyicc/libsndfile")
endif ()

# SRELL
if (CPPMODULE_SRELL)
  message("[BSD-2-Clause] SRELL: ON | By: https://github.com/Huiyicc/SRELL")
  include(${CPPMODULES}/scripts/SRELL.cmake)

else ()
  message("[BSD-2-Clause] SRELL: OFF | By: https://github.com/Huiyicc/SRELL")
endif ()

# utfcpp
if (CPPMODULE_UTFCPP)
  message("[BSL-1.0] utfcpp: ON | By: https://github.com/Huiyicc/utfcpp")
  include(${CPPMODULES}/scripts/utfcpp.cmake)
else ()
  message("[BSL-1.0] utfcpp: OFF | By: https://github.com/Huiyicc/utfcpp")
endif ()


# cppjieba
if (CPPMODULE_CPPJIEBA)
  message("[MIT] cppjieba: ON | By: https://github.com/Huiyicc/cppjieba")
  include(${CPPMODULES}/scripts/cppjieba.cmake)
else ()
  message("[MIT] cppjieba: OFF | By: https://github.com/Huiyicc/cppjieba")
endif ()

# libsamplerate
if (CPPMODULE_LIBSAMPLERATE)
  message("[BSD-2-Clause] libsamplerate: ON | By: https://github.com/Huiyicc/libsamplerate")
  include(${CPPMODULES}/scripts/libsamplerate.cmake)
else ()
  message("[BSD-2-Clause] libsamplerate: OFF | By: https://github.com/Huiyicc/libsamplerate")
endif ()


# cld2-cmake
if (CPPMODULE_CLD2)
  message("[Apache-2.0] cld2-cmake: ON | By: https://github.com/Huiyicc/cld2-cmake")
  include(${CPPMODULES}/scripts/cld2-cmake.cmake)
else ()
  message("[Apache-2.0] cld2-cmake: OFF | By: https://github.com/Huiyicc/cld2-cmake")
endif ()

# xtl
if (CPPMODULE_XTL)
  message("[BSD-3-Clause] xtl: ON | By: https://github.com/Huiyicc/xtl")
  include(${CPPMODULES}/scripts/xtl.cmake)
else ()
  message("[BSD-3-Clause] xtl: OFF | By: https://github.com/Huiyicc/xtl")
endif ()

# xtensor-blas
if (CPPMODULE_XTENSOR_BLAS)
  message("[BSD-3-Clause] xtl: ON | By: https://github.com/Huiyicc/xtensor-blas")
  include(${CPPMODULES}/scripts/xtensor-blas.cmake)
else ()
  message("[BSD-3-Clause] xtl: OFF | By: https://github.com/Huiyicc/xtensor-blas")
endif ()

# xtensor
if (CPPMODULE_XTENSOR)
  message("[BSD-3-Clause] xtensor: ON | By: https://github.com/Huiyicc/xtensor")
  include(${CPPMODULES}/scripts/xtensor.cmake)
else ()
  message("[BSD-3-Clause] xtensor: OFF | By: https://github.com/Huiyicc/xtensor")
endif ()

# fmt
if (CPPMODULE_FMT)
  message("[MIT] fmt: ON | By: https://github.com/Huiyicc/fmt")
  include(${CPPMODULES}/scripts/fmt.cmake)
else ()
  message("[MIT] fmt: OFF | By: https://github.com/Huiyicc/fmt")
endif ()

# gpt_sovits_cpp
if (CPPMODULE_GPTSOVITSCPP)
  message("[MIT] gpt_sovits_cpp: ON | By: https://github.com/Huiyicc/gpt_sovits_cpp")
  include(${CPPMODULES}/scripts/gpt_sovits_cpp.cmake)
else ()
  message("[MIT] gpt_sovits_cpp: OFF | By: https://github.com/Huiyicc/gpt_sovits_cpp")
endif ()


# freetype2
if (CPPMODULE_FREETYPE2)
  message("[FreeType License] freetype2: ON | By: https://github.com/Huiyicc/freetype2")
  include(${CPPMODULES}/scripts/freetype2.cmake)
else ()
  message("[FreeType License] freetype2: OFF | By: https://github.com/Huiyicc/freetype2")
endif ()


# lvgl
if (CPPMODULE_LVGL)
  message("[MIT] LVGL: ON | By: https://github.com/Huiyicc/lvgl")
  include(${CPPMODULES}/scripts/lvgl.cmake)
else ()
  message("[MIT] lvgl: OFF | By: https://github.com/Huiyicc/lvgl")
endif ()

# LVGLEx
if (CPPMODULE_LVGLEX)
  message("[MIT] LVGLEx: ON | By: https://github.com/Huiyicc/LVGLEx")
  include(${CPPMODULES}/scripts/LVGLEx.cmake)
else ()
  message("[MIT] gpt_sovits_cpp: OFF | By: https://github.com/Huiyicc/LVGLEx")
endif ()


message("===== INCLUDE C++ MODULES END =====")
message("Please use
add_executable(you_target_name you_target_sources \${CPPMODULE_LINK_SOURCES})
target_link_libraries(you_target_name \${CPPMODULE_LINK_LIBRARIES})")
