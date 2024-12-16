set(LIBSAMPLERATE_TESTS OFF)
include_directories(${CPPMODULE_ROOTPATH}/libsamplerate/include)
add_subdirectory(${CPPMODULE_ROOTPATH}/libsamplerate ${CPPMODULE_BINARY_SUBDIR}/libsamplerate)
set(CPPMODULE_LINK_LIBRARIES_ALL ${CPPMODULE_LINK_LIBRARIES_ALL} samplerate)
set(CPPMODULE_LINK_LIBRARIES_LIBSAMPLERATE samplerate)