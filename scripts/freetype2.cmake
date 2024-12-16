include_directories(${CPPMODULE_ROOTPATH}/freetype2/include)
include_directories(${CPPMODULE_BINARY_SUBDIR}/freetype2/include)
#  add_subdirectory(${CPPMODULE_ROOTPATH}/freetype2 ${CPPMODULE_BINARY_SUBDIR}/freetype2)

if(OS_IS_WINDOWS)
  set(CPPMODULE_FREETYPE2_SOURCES
      ${CPPMODULE_ROOTPATH}/freetype2/src/autofit/autofit.c
      ${CPPMODULE_ROOTPATH}/freetype2/src/base/ftbase.c
      ${CPPMODULE_ROOTPATH}/freetype2/src/base/ftbbox.c
      ${CPPMODULE_ROOTPATH}/freetype2/src/base/ftbdf.c
      ${CPPMODULE_ROOTPATH}/freetype2/src/base/ftbitmap.c
      ${CPPMODULE_ROOTPATH}/freetype2/src/base/ftcid.c
      ${CPPMODULE_ROOTPATH}/freetype2/src/base/ftfstype.c
      ${CPPMODULE_ROOTPATH}/freetype2/src/base/ftgasp.c
      ${CPPMODULE_ROOTPATH}/freetype2/src/base/ftglyph.c
      ${CPPMODULE_ROOTPATH}/freetype2/src/base/ftgxval.c
      ${CPPMODULE_ROOTPATH}/freetype2/src/base/ftinit.c
      ${CPPMODULE_ROOTPATH}/freetype2/src/base/ftmm.c
      ${CPPMODULE_ROOTPATH}/freetype2/src/base/ftotval.c
      ${CPPMODULE_ROOTPATH}/freetype2/src/base/ftpatent.c
      ${CPPMODULE_ROOTPATH}/freetype2/src/base/ftpfr.c
      ${CPPMODULE_ROOTPATH}/freetype2/src/base/ftstroke.c
      ${CPPMODULE_ROOTPATH}/freetype2/src/base/ftsynth.c
      ${CPPMODULE_ROOTPATH}/freetype2/src/base/fttype1.c
      ${CPPMODULE_ROOTPATH}/freetype2/src/base/ftwinfnt.c
      ${CPPMODULE_ROOTPATH}/freetype2/src/bdf/bdf.c
      ${CPPMODULE_ROOTPATH}/freetype2/src/cache/ftcache.c
      ${CPPMODULE_ROOTPATH}/freetype2/src/cff/cff.c
      ${CPPMODULE_ROOTPATH}/freetype2/src/cid/type1cid.c
      ${CPPMODULE_ROOTPATH}/freetype2/src/dlg/dlgwrap.c
      ${CPPMODULE_ROOTPATH}/freetype2/src/gzip/ftgzip.c
      ${CPPMODULE_ROOTPATH}/freetype2/src/lzw/ftlzw.c
      ${CPPMODULE_ROOTPATH}/freetype2/src/pcf/pcf.c
      ${CPPMODULE_ROOTPATH}/freetype2/src/pfr/pfr.c
      ${CPPMODULE_ROOTPATH}/freetype2/src/psaux/psaux.c
      ${CPPMODULE_ROOTPATH}/freetype2/src/pshinter/pshinter.c
      ${CPPMODULE_ROOTPATH}/freetype2/src/psnames/psmodule.c
      ${CPPMODULE_ROOTPATH}/freetype2/src/raster/raster.c
      ${CPPMODULE_ROOTPATH}/freetype2/src/sfnt/sfnt.c
      ${CPPMODULE_ROOTPATH}/freetype2/src/smooth/smooth.c
      ${CPPMODULE_ROOTPATH}/freetype2/src/sdf/sdf.c
      ${CPPMODULE_ROOTPATH}/freetype2/src/svg/svg.c
      ${CPPMODULE_ROOTPATH}/freetype2/src/truetype/truetype.c
      ${CPPMODULE_ROOTPATH}/freetype2/src/type1/type1.c
      ${CPPMODULE_ROOTPATH}/freetype2/src/type42/type42.c
      ${CPPMODULE_ROOTPATH}/freetype2/src/winfonts/winfnt.c
      ${CPPMODULE_ROOTPATH}/freetype2/builds/windows/ftdebug.c
      ${CPPMODULE_ROOTPATH}/freetype2/builds/windows/ftsystem.c
      ${CPPMODULE_ROOTPATH}/freetype2/src/base/ftver.rc)

  add_library(freetype STATIC ${CPPMODULE_FREETYPE2_SOURCES})
  target_compile_definitions(freetype PRIVATE _LIB
      _CRT_SECURE_NO_WARNINGS
      FT2_BUILD_LIBRARY)
else ()
  add_subdirectory(${CPPMODULE_ROOTPATH}/freetype2 ${CPPMODULE_BINARY_SUBDIR}/freetype2)
endif ()

set(CPPMODULE_LINK_LIBRARIES_FREETYPE2 freetype)
set(CPPMODULE_LINK_LIBRARIES_ALL ${CPPMODULE_LINK_LIBRARIES_ALL} ${CPPMODULE_LINK_LIBRARIES_FREETYPE2})