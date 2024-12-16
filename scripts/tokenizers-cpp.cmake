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