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
  include_directories(${CPPMODULE_ROOTPATH}/json/include)
else ()
  message("[MIT] nlohmann/json: OFF | By: https://github.com/huiyicc/json")
endif ()

# cpp-pinyin
if (CPPMODULE_CPPPINYIN)
  message("[Apache-2.0] cpp-pinyin: ON | https://github.com/Huiyicc/cpp-pinyin.git")
  include_directories(${CPPMODULE_ROOTPATH}/cpp-pinyin/include)
  set(CPP_PINYIN_BUILD_TESTS OFF)
  set(CPP_PINYIN_INSTALL OFF)
  add_subdirectory(${CPPMODULE_ROOTPATH}/cpp-pinyin ${CPPMODULE_BINARY_SUBDIR}/cpp-pinyin)
  set(CPPMODULE_LINK_LIBRARIES_ALL ${CPPMODULE_LINK_LIBRARIES_ALL} cpp-pinyin::cpp-pinyin)
  set(CPPMODULE_LINK_LIBRARIES_CPPPINYIN cpp-pinyin::cpp-pinyin)

else ()
  message("[Apache-2.0] cpp-pinyin: OFF | https://github.com/Huiyicc/cpp-pinyin.git")
endif ()


# boost-cmake
if (CPPMODULE_BOOSTCMAKE)
  message("[Boost Software] boost-cmake: ON | https://github.com/OpenHYGUI/boost-cmake")

  set(__CPPMODULE_TEMP_BOOST_LIB__
      Boost::boost
      Boost::system Boost::atomic
      Boost::thread
      Boost::context
      Boost::coroutine
      Boost::chrono
      Boost::filesystem
      Boost::date_time
      Boost::regex
      Boost::timer
      Boost::exception
      Boost::random
      Boost::program_options
      Boost::asio
      Boost::test
      Boost::beast
  )

  set(Boost_USE_STATIC_LIBS ON)
  set(Boost_USE_STATIC_RUNTIME ON)

  if ((CPPMODULE_BOOSTCMAKE_ENABLE_ALL OR CPPMODULE_BOOSTCMAKE_ENABLE_SERIALIZATION) AND NOT CPPMODULE_BOOSTCMAKE_DISABLE_SERIALIZATION)
    set(USE_BOOST_SERIALIZATION ON)
    set(__CPPMODULE_TEMP_BOOST_LIB__ ${__CPPMODULE_TEMP_BOOST_LIB__}
        Boost::serialization
    )
  endif ()

  if ((CPPMODULE_BOOSTCMAKE_ENABLE_ALL OR CPPMODULE_BOOSTCMAKE_ENABLE_FIBER) AND NOT CPPMODULE_BOOSTCMAKE_DISABLE_FIBER)
    set(USE_BOOST_FIBER ON)
    set(__CPPMODULE_TEMP_BOOST_LIB__ ${__CPPMODULE_TEMP_BOOST_LIB__}
        Boost::fiber
    )
  endif ()

  if ((CPPMODULE_BOOSTCMAKE_ENABLE_ALL OR CPPMODULE_BOOSTCMAKE_ENABLE_LOCALE) AND NOT CPPMODULE_BOOSTCMAKE_DISABLE_LOCALE)
    set(USE_BOOST_LOCALE ON)
    set(__CPPMODULE_TEMP_BOOST_LIB__ ${__CPPMODULE_TEMP_BOOST_LIB__}
        Boost::locale
    )
  endif ()

  add_subdirectory(${CPPMODULE_ROOTPATH}/boost ${CPPMODULE_BINARY_SUBDIR}/boost)
  include_directories(${CPPMODULE_ROOTPATH}/boost)

  set(CPPMODULE_LINK_LIBRARIES_ALL ${CPPMODULE_LINK_LIBRARIES_ALL} ${__CPPMODULE_TEMP_BOOST_LIB__})
  set(CPPMODULE_LINK_LIBRARIES_BOOSTCMAKE ${__CPPMODULE_TEMP_BOOST_LIB__})
else ()
  message("[Boost Software] boost-cmake: OFF | https://github.com/OpenHYGUI/boost-cmake")
endif ()


# SDL
if (CPPMODULE_SDL)
  message("[Zlib] SDL: ON | https://github.com/libsdl-org/SDL")

  set(EP_SDL_DIR ${CPPMODULE_ROOTPATH}/SDL)
  set(SDL_INSTALL_PATH ${CPPMODULE_ROOTPATH}/SDL/install)
  set(SDL_BINARY_PATH ${CPPMODULE_ROOTPATH}/SDL)

  if (CMAKE_HOST_WIN32)
    #  add_definitions(-DWIN32)
    #  add_definitions(-D_WINDOWS)
    add_definitions(-DUSING_GENERATED_CONFIG_H)
    add_definitions(-D_CRT_SECURE_NO_DEPRECATE)
    add_definitions(-D_NO_CRT_STDIO_INLINE)
    add_definitions(-D_CRT_NONSTDC_NO_DEPRECATE)
    add_definitions(-D_CRT_SECURE_NO_WARNINGS)
    add_definitions(-DSDL_BUILD_MAJOR_VERSION=3)
    add_definitions(-DSDL_BUILD_MINOR_VERSION=1)
    add_definitions(-DSDL_BUILD_MICRO_VERSION=2)
    #  add_definitions(-DCMAKE_INTDIR="${CMAKE_BUILD_TYPE}")
    #  add_definitions(-DDLL_EXPORT)
    set(WINDOWS_STORE OFF)
    set(SDL_LIBC ON)

  endif ()
  set(SDL_STATIC ON)
  set(SDL_SHARED OFF)

  add_subdirectory(${CPPMODULE_ROOTPATH}/SDL ${CPPMODULE_BINARY_SUBDIR}/SDL)
  include_directories(${CPPMODULE_ROOTPATH}/SDL/include)

  set(__CPPMODULE_TEMP_SDL_LIB__ SDL3::SDL3 SDL3::Headers SDL_uclibc SDL3::SDL3-static)
  if (CPPMODULE_SDL_ENABLE_OPENGL)
    if (OS_IS_WINDOWS)
      set(__CPPMODULE_TEMP_SDL_LIB__ ${__CPPMODULE_TEMP_SDL_LIB__} opengl32.lib Winmm Setupapi Imm32 Version dwmapi legacy_stdio_definitions)
    elseif (OS_IS_APPLE)
      set(__CPPMODULE_TEMP_SDL_LIB__ ${__CPPMODULE_TEMP_SDL_LIB__} OpenGL::GL)
    elseif (OS_IS_LINUX)
      set(__CPPMODULE_TEMP_SDL_LIB__ ${__CPPMODULE_TEMP_SDL_LIB__} X11 GL GLU glut)
    endif ()
  endif ()
  set(CPPMODULE_LINK_LIBRARIES_ALL ${CPPMODULE_LINK_LIBRARIES_ALL} ${__CPPMODULE_TEMP_SDL_LIB__})
  set(CPPMODULE_LINK_LIBRARIES_SDL ${__CPPMODULE_TEMP_SDL_LIB__})

else ()
  message("[Zlib] SDL: OFF | https://github.com/libsdl-org/SDL")
endif ()

# tokenizers-cpp
if (CPPMODULE_TOKENIZERS)
  message("[Apache-2.0] tokenizers-cpp: ON | By: https://github.com/Huiyicc/tokenizers-cpp")
  if (NOT EXISTS "${CPPMODULE_ROOTPATH}/tokenizers-cpp")

    message("Initial tokenizers-cpp submodules")
    execute_process(
        COMMAND git submodule update --init
        WORKING_DIRECTORY ${CPPMODULE_ROOTPATH}/tokenizers-cpp
        RESULT_VARIABLE result
    )
    if (NOT result EQUAL 0)
      message(FATAL_ERROR "tokenizers-cpp: Failed to initialize and update git submodules")
    endif ()
  endif ()
  add_subdirectory(${CPPMODULE_ROOTPATH}/tokenizers-cpp ${CPPMODULE_BINARY_SUBDIR}/tokenizers-cpp)
  include_directories(${CPPMODULE_ROOTPATH}/tokenizers-cpp/include)
  set(CPPMODULE_LINK_LIBRARIES_ALL ${CPPMODULE_LINK_LIBRARIES_ALL} tokenizers_cpp)
  set(CPPMODULE_LINK_LIBRARIES_TOKENIZERS tokenizers_cpp)
else ()
  message("[Apache-2.0] tokenizers-cpp: OFF | By: https://github.com/Huiyicc/tokenizers-cpp")
endif ()

# libsndfile
if (CPPMODULE_LIBSNDFILE)
  message("[LGPL-2.1] libsndfile: ON | By: https://github.com/Huiyicc/libsndfile")
  set(INSTALL_MANPAGES OFF)
  set(BUILD_SHARED_LIBS OFF)
  if (MSVC)
    unset(ENABLE_STATIC_RUNTIME CACHE)
    set(ENABLE_STATIC_RUNTIME ON)
  else ()
    set(ENABLE_STATIC_RUNTIME ON)
  endif ()
  add_subdirectory(${CPPMODULE_ROOTPATH}/libsndfile ${CPPMODULE_BINARY_SUBDIR}/libsndfile)
  include_directories(${CPPMODULE_ROOTPATH}/libsndfile/include)
  set(CPPMODULE_LINK_LIBRARIES_ALL ${CPPMODULE_LINK_LIBRARIES_ALL} SndFile::sndfile)
  set(CPPMODULE_LINK_LIBRARIES_LIBSNDFILE SndFile::sndfile)
else ()
  message("[LGPL-2.1] libsndfile: OFF | By: https://github.com/Huiyicc/libsndfile")
endif ()

# SRELL
if (CPPMODULE_SRELL)
  message("[BSD-2-Clause] SRELL: ON | By: https://github.com/Huiyicc/SRELL")
  include_directories(${CPPMODULE_ROOTPATH}/SRELL)

else ()
  message("[BSD-2-Clause] SRELL: OFF | By: https://github.com/Huiyicc/SRELL")
endif ()

# utfcpp
if (CPPMODULE_UTFCPP)
  message("[BSL-1.0] utfcpp: ON | By: https://github.com/Huiyicc/utfcpp")
  include_directories(${CPPMODULE_ROOTPATH}/utfcpp/source)
else ()
  message("[BSL-1.0] utfcpp: OFF | By: https://github.com/Huiyicc/utfcpp")
endif ()


# cppjieba
if (CPPMODULE_CPPJIEBA)
  message("[MIT] cppjieba: ON | By: https://github.com/Huiyicc/cppjieba")
  include_directories(${CPPMODULE_ROOTPATH}/cppjieba/include)
  include_directories(${CPPMODULE_ROOTPATH}/cppjieba/deps/limonp/include)
  add_subdirectory(${CPPMODULE_ROOTPATH}/cppjieba ${CPPMODULE_BINARY_SUBDIR}/cppjieba)
  set(CPPMODULE_LINK_LIBRARIES_ALL ${CPPMODULE_LINK_LIBRARIES_ALL} cppjieba_static)
  set(CPPMODULE_LINK_LIBRARIES_CPPJIEBA cppjieba_static)
else ()
  message("[MIT] cppjieba: OFF | By: https://github.com/Huiyicc/cppjieba")
endif ()

# libsamplerate
if (CPPMODULE_LIBSAMPLERATE)
  message("[BSD-2-Clause] libsamplerate: ON | By: https://github.com/Huiyicc/libsamplerate")
  set(LIBSAMPLERATE_TESTS OFF)
  include_directories(${CPPMODULE_ROOTPATH}/libsamplerate/include)
  add_subdirectory(${CPPMODULE_ROOTPATH}/libsamplerate ${CPPMODULE_BINARY_SUBDIR}/libsamplerate)
  set(CPPMODULE_LINK_LIBRARIES_ALL ${CPPMODULE_LINK_LIBRARIES_ALL} samplerate)
  set(CPPMODULE_LINK_LIBRARIES_LIBSAMPLERATE samplerate)
else ()
  message("[BSD-2-Clause] libsamplerate: OFF | By: https://github.com/Huiyicc/libsamplerate")
endif ()


# cld2-cmake
if (CPPMODULE_CLD2)
  message("[Apache-2.0] cld2-cmake: ON | By: https://github.com/Huiyicc/cld2-cmake")
  include_directories(${CPPMODULE_ROOTPATH}/cld2-cmake/public)
  add_subdirectory(${CPPMODULE_ROOTPATH}/cld2-cmake ${CPPMODULE_BINARY_SUBDIR}/cld2-cmake)
  set(CPPMODULE_LINK_LIBRARIES_ALL ${CPPMODULE_LINK_LIBRARIES_ALL} CLD2-static)
  set(CPPMODULE_LINK_LIBRARIES_LIBCLD2 CLD2-static)
else ()
  message("[Apache-2.0] cld2-cmake: OFF | By: https://github.com/Huiyicc/cld2-cmake")
endif ()

#
## NumCpp
#if (CPPMODULE_NUMCPP)
#  message("[MIT] NumCpp: ON | By: https://github.com/Huiyicc/NumCpp")
#  include_directories(${CPPMODULE_ROOTPATH}/NumCpp/include)
##  add_subdirectory(${CPPMODULE_ROOTPATH}/NumCpp ${CPPMODULE_BINARY_SUBDIR}/NumCpp)
##  set(CPPMODULE_LINK_LIBRARIES_ALL ${CPPMODULE_LINK_LIBRARIES_ALL} NumCpp::NumCpp)
##  set(CPPMODULE_LINK_LIBRARIES_NUMCPP NumCpp::NumCpp)
#else ()
#  message("[MIT] NumCpp: OFF | By: https://github.com/Huiyicc/NumCpp")
#endif ()

# xtl
if (CPPMODULE_XTL)
  message("[BSD-3-Clause] xtl: ON | By: https://github.com/Huiyicc/xtl")
  include_directories(${CPPMODULE_ROOTPATH}/xtl/include)
else ()
  message("[BSD-3-Clause] xtl: OFF | By: https://github.com/Huiyicc/xtl")
endif ()

# xtensor-blas
if (CPPMODULE_XTENSOR_BLAS)
  message("[BSD-3-Clause] xtl: ON | By: https://github.com/Huiyicc/xtensor-blas")
  include_directories(${CPPMODULE_ROOTPATH}/xtensor-blas/include)
else ()
  message("[BSD-3-Clause] xtl: OFF | By: https://github.com/Huiyicc/xtensor-blas")
endif ()

# xtensor
if (CPPMODULE_XTENSOR)
  message("[BSD-3-Clause] xtensor: ON | By: https://github.com/Huiyicc/xtensor")
  include_directories(${CPPMODULE_ROOTPATH}/xtensor/include)
else ()
  message("[BSD-3-Clause] xtensor: OFF | By: https://github.com/Huiyicc/xtensor")
endif ()

# fmt
if (CPPMODULE_FMT)
  message("[MIT] fmt: ON | By: https://github.com/Huiyicc/fmt")
  include_directories(${CPPMODULE_ROOTPATH}/fmt/include)
  add_subdirectory(${CPPMODULE_ROOTPATH}/fmt ${CPPMODULE_BINARY_SUBDIR}/fmt)
  set(CPPMODULE_LINK_LIBRARIES_ALL ${CPPMODULE_LINK_LIBRARIES_ALL} fmt::fmt)
  set(CPPMODULE_LINK_LIBRARIES_FMT fmt::fmt)
else ()
  message("[MIT] fmt: OFF | By: https://github.com/Huiyicc/fmt")
endif ()

# gpt_sovits_cpp
if (CPPMODULE_GPTSOVITSCPP)
  message("[MIT] gpt_sovits_cpp: ON | By: https://github.com/Huiyicc/gpt_sovits_cpp")
  CHECK_SUB(CPPMODULE_JSON
      CPPMODULE_FMT
      CPPMODULE_CPPPINYIN
      CPPMODULE_BOOSTCMAKE
      CPPMODULE_BOOSTCMAKE_ENABLE_ALL
      CPPMODULE_TOKENIZERS
      CPPMODULE_UTFCPP
      CPPMODULE_SRELL
      CPPMODULE_LIBSNDFILE
      CPPMODULE_CPPJIEBA
      CPPMODULE_LIBSAMPLERATE
      CPPMODULE_CLD2
      CPPMODULE_XTL
      CPPMODULE_XTENSOR_BLAS
      CPPMODULE_XTENSOR
  )
  include_directories(${CPPMODULE_ROOTPATH}/gpt_sovits_cpp/include)
  add_subdirectory(${CPPMODULE_ROOTPATH}/gpt_sovits_cpp ${CPPMODULE_BINARY_SUBDIR}/gpt_sovits_cpp)
  set(CPPMODULE_LINK_LIBRARIES_ALL ${CPPMODULE_LINK_LIBRARIES_ALL} gpt_sovits_cpp_static)
  set(CPPMODULE_LINK_LIBRARIES_GPTSOVITSCPP gpt_sovits_cpp_static)
else ()
  message("[MIT] gpt_sovits_cpp: OFF | By: https://github.com/Huiyicc/gpt_sovits_cpp")
endif ()

#
## armadillo-code
#if (CPPMODULE_ARMADILLO)
#  message("[Apache-2.0] mlpack: ON | By: https://github.com/Huiyicc/armadillo-code")
#  include_directories(${CPPMODULE_ROOTPATH}/armadillo-code/include)
##  add_subdirectory(${CPPMODULE_ROOTPATH}/armadillo-code ${CPPMODULE_BINARY_SUBDIR}/armadillo-code)
#else ()
#  message("[Apache-2.0] mlpack: OFF | By: https://github.com/Huiyicc/armadillo-code")
#endif ()
#
## ensmallen
#if (CPPMODULE_ENSMALLEN)
#  message("[BSD-3-clause] mlpack: ON | By: https://github.com/Huiyicc/ensmallen")
#  include_directories(${CPPMODULE_ROOTPATH}/ensmallen/include)
#  set(ARMADILLO_INCLUDE_DIR ${CPPMODULE_ROOTPATH}/armadillo-code/include)
##  add_subdirectory(${CPPMODULE_ROOTPATH}/ensmallen ${CPPMODULE_BINARY_SUBDIR}/ensmallen)
#else ()
#  message("[BSD-3-clause] mlpack: OFF | By: https://github.com/Huiyicc/ensmallen")
#endif ()
#
## cereal
#if (CPPMODULE_CEREAL)
#  message("[BSD-3-Clause] mlpack: ON | By: https://github.com/Huiyicc/cereal")
#  include_directories(${CPPMODULE_ROOTPATH}/cereal/include)
##  add_subdirectory(${CPPMODULE_ROOTPATH}/cereal ${CPPMODULE_BINARY_SUBDIR}/cereal)
#else ()
#  message("[BSD 3-clause] mlpack: OFF | By: https://github.com/Huiyicc/cereal")
#endif ()
#
## mlpack
#if (CPPMODULE_MLPACK)
#  message("[None] mlpack: ON | By: https://github.com/Huiyicc/mlpack")
#  set(ARMADILLO_INCLUDE_DIR ${CPPMODULE_ROOTPATH}/armadillo-code/include)
#  set(ENSMALLEN_INCLUDE_DIR ${CPPMODULE_ROOTPATH}/ensmallen/include)
#  set(CEREAL_INCLUDE_DIR ${CPPMODULE_ROOTPATH}/cereal/include)
#  include_directories(${CPPMODULE_ROOTPATH}/mlpack/src)
#  add_subdirectory(${CPPMODULE_ROOTPATH}/mlpack ${CPPMODULE_BINARY_SUBDIR}/mlpack)
#else ()
#  message("[None] mlpack: OFF | By: https://github.com/Huiyicc/mlpack")
#endif ()

message("===== INCLUDE C++ MODULES END =====")
message("Please use
add_executable(you_target_name you_target_sources \${CPPMODULE_LINK_SOURCES})
target_link_libraries(you_target_name \${CPPMODULE_LINK_LIBRARIES})")
