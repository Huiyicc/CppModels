# options:
# CPPMODULE_JSON


message("===== INCLUDE C++ MODULES BEGIN =====")

set(CPPMODULE_ROOTPATH ${CMAKE_CURRENT_LIST_DIR})
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

# =========

set(CPPMODULE_LINK_ALL_LIBRARIES "")
set(CPPMODULE_LINK_SOURCES "")

if ((CMAKE_HOST_SYSTEM_NAME MATCHES "Darwin"))
  set(OS_IS_APPLE TRUE)
  add_definitions(-D_HOST_APPLE_)
elseif (CMAKE_HOST_WIN32)
  set(OS_IS_WINDOWS TRUE)
  add_definitions(-D_HOST_WINDOWS_)
elseif (CMAKE_HOST_UNIX)
  set(OS_IS_LINUX TRUE)
  add_definitions(-D_HOST_LINUX_)
else ()
  message(FATAL_ERROR "The platform is not currently supported。")
endif ()

# nlohmann json
if (CPPMODULE_JSON)
  message("nlohmann/json: ON | By: https://github.com/huiyicc/json")
  include_directories(${CPPMODULE_ROOTPATH}/json/include)
else ()
  message("nlohmann/json: OFF | By: https://github.com/huiyicc/json")
endif ()

# cpp-pinyin
if (CPPMODULE_CPPPINYIN)
  message("cpp-pinyin: ON | https://github.com/Huiyicc/cpp-pinyin.git")
  include_directories(${CPPMODULE_ROOTPATH}/cpp-pinyin/include)
  set(CPP_PINYIN_BUILD_TESTS OFF)
  set(CPP_PINYIN_INSTALL OFF)
  add_subdirectory(${CPPMODULE_ROOTPATH}/cpp-pinyin ${CPPMODULE_BINARY_SUBDIR}/cpp-pinyin)
  set(CPPMODULE_LINK_ALL_LIBRARIES ${CPPMODULE_LINK_LIBRARIES} cpp-pinyin::cpp-pinyin)
  set(CPPMODULE_LINK_LIBRARIES_CPPPINYIN cpp-pinyin::cpp-pinyin)
else ()
  message("cpp-pinyin: OFF | https://github.com/Huiyicc/cpp-pinyin.git")
endif ()


# boost-cmake
if (CPPMODULE_BOOSTCMAKE)
  message("boost-cmake: ON | https://github.com/OpenHYGUI/boost-cmake")

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

  set(CPPMODULE_LINK_ALL_LIBRARIES ${CPPMODULE_LINK_LIBRARIES} ${__CPPMODULE_TEMP_BOOST_LIB__})
  set(CPPMODULE_LINK_LIBRARIES_BOOSTCMAKE ${__CPPMODULE_TEMP_BOOST_LIB__})
else ()
  message("boost-cmake: OFF | https://github.com/OpenHYGUI/boost-cmake")
endif ()


# SDL
if (CPPMODULE_SDL)
  message("SDL: ON | https://github.com/libsdl-org/SDL")

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
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
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
  set(CPPMODULE_LINK_ALL_LIBRARIES ${CPPMODULE_LINK_LIBRARIES} ${__CPPMODULE_TEMP_SDL_LIB__})
  set(CPPMODULE_LINK_LIBRARIES_SDL ${__CPPMODULE_TEMP_SDL_LIB__})

else ()
  message("SDL: OFF | https://github.com/libsdl-org/SDL")
endif ()


message("===== INCLUDE C++ MODULES END =====")
message("Please use
add_executable(you_target_name you_target_sources \${CPPMODULE_LINK_SOURCES})
target_link_libraries(you_target_name \${CPPMODULE_LINK_LIBRARIES})")
