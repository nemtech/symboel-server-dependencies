

function(conan_message MESSAGE_OUTPUT)
    if(NOT CONAN_CMAKE_SILENT_OUTPUT)
        message(${ARGV${0}})
    endif()
endfunction()


macro(conan_find_apple_frameworks FRAMEWORKS_FOUND FRAMEWORKS FRAMEWORKS_DIRS)
    if(APPLE)
        foreach(_FRAMEWORK ${FRAMEWORKS})
            # https://cmake.org/pipermail/cmake-developers/2017-August/030199.html
            find_library(CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND NAMES ${_FRAMEWORK} PATHS ${FRAMEWORKS_DIRS} CMAKE_FIND_ROOT_PATH_BOTH)
            if(CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND)
                list(APPEND ${FRAMEWORKS_FOUND} ${CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND})
            else()
                message(FATAL_ERROR "Framework library ${_FRAMEWORK} not found in paths: ${FRAMEWORKS_DIRS}")
            endif()
        endforeach()
    endif()
endmacro()


function(conan_package_library_targets libraries package_libdir deps out_libraries out_libraries_target build_type package_name)
    unset(_CONAN_ACTUAL_TARGETS CACHE)
    unset(_CONAN_FOUND_SYSTEM_LIBS CACHE)
    foreach(_LIBRARY_NAME ${libraries})
        find_library(CONAN_FOUND_LIBRARY NAMES ${_LIBRARY_NAME} PATHS ${package_libdir}
                     NO_DEFAULT_PATH NO_CMAKE_FIND_ROOT_PATH)
        if(CONAN_FOUND_LIBRARY)
            conan_message(STATUS "Library ${_LIBRARY_NAME} found ${CONAN_FOUND_LIBRARY}")
            list(APPEND _out_libraries ${CONAN_FOUND_LIBRARY})
            if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
                # Create a micro-target for each lib/a found
                string(REGEX REPLACE "[^A-Za-z0-9.+_-]" "_" _LIBRARY_NAME ${_LIBRARY_NAME})
                set(_LIB_NAME CONAN_LIB::${package_name}_${_LIBRARY_NAME}${build_type})
                if(NOT TARGET ${_LIB_NAME})
                    # Create a micro-target for each lib/a found
                    add_library(${_LIB_NAME} UNKNOWN IMPORTED)
                    set_target_properties(${_LIB_NAME} PROPERTIES IMPORTED_LOCATION ${CONAN_FOUND_LIBRARY})
                    set(_CONAN_ACTUAL_TARGETS ${_CONAN_ACTUAL_TARGETS} ${_LIB_NAME})
                else()
                    conan_message(STATUS "Skipping already existing target: ${_LIB_NAME}")
                endif()
                list(APPEND _out_libraries_target ${_LIB_NAME})
            endif()
            conan_message(STATUS "Found: ${CONAN_FOUND_LIBRARY}")
        else()
            conan_message(STATUS "Library ${_LIBRARY_NAME} not found in package, might be system one")
            list(APPEND _out_libraries_target ${_LIBRARY_NAME})
            list(APPEND _out_libraries ${_LIBRARY_NAME})
            set(_CONAN_FOUND_SYSTEM_LIBS "${_CONAN_FOUND_SYSTEM_LIBS};${_LIBRARY_NAME}")
        endif()
        unset(CONAN_FOUND_LIBRARY CACHE)
    endforeach()

    if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
        # Add all dependencies to all targets
        string(REPLACE " " ";" deps_list "${deps}")
        foreach(_CONAN_ACTUAL_TARGET ${_CONAN_ACTUAL_TARGETS})
            set_property(TARGET ${_CONAN_ACTUAL_TARGET} PROPERTY INTERFACE_LINK_LIBRARIES "${_CONAN_FOUND_SYSTEM_LIBS};${deps_list}")
        endforeach()
    endif()

    set(${out_libraries} ${_out_libraries} PARENT_SCOPE)
    set(${out_libraries_target} ${_out_libraries_target} PARENT_SCOPE)
endfunction()


include(FindPackageHandleStandardArgs)

conan_message(STATUS "Conan: Using autogenerated FindZeroMQ.cmake")
# Global approach
set(ZeroMQ_FOUND 1)
set(ZeroMQ_VERSION "4.3.5")

find_package_handle_standard_args(ZeroMQ REQUIRED_VARS
                                  ZeroMQ_VERSION VERSION_VAR ZeroMQ_VERSION)
mark_as_advanced(ZeroMQ_FOUND ZeroMQ_VERSION)


set(ZeroMQ_INCLUDE_DIRS "/home/ubuntu/.conan/data/zeromq/4.3.5/nemtech/stable/package/9428c85bc64cf85711c31a116b265ea0dd5903a4/include")
set(ZeroMQ_INCLUDE_DIR "/home/ubuntu/.conan/data/zeromq/4.3.5/nemtech/stable/package/9428c85bc64cf85711c31a116b265ea0dd5903a4/include")
set(ZeroMQ_INCLUDES "/home/ubuntu/.conan/data/zeromq/4.3.5/nemtech/stable/package/9428c85bc64cf85711c31a116b265ea0dd5903a4/include")
set(ZeroMQ_RES_DIRS )
set(ZeroMQ_DEFINITIONS )
set(ZeroMQ_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(ZeroMQ_COMPILE_DEFINITIONS )
set(ZeroMQ_COMPILE_OPTIONS_LIST "" "")
set(ZeroMQ_COMPILE_OPTIONS_C "")
set(ZeroMQ_COMPILE_OPTIONS_CXX "")
set(ZeroMQ_LIBRARIES_TARGETS "") # Will be filled later, if CMake 3
set(ZeroMQ_LIBRARIES "") # Will be filled later
set(ZeroMQ_LIBS "") # Same as ZeroMQ_LIBRARIES
set(ZeroMQ_SYSTEM_LIBS pthread rt m)
set(ZeroMQ_FRAMEWORK_DIRS )
set(ZeroMQ_FRAMEWORKS )
set(ZeroMQ_FRAMEWORKS_FOUND "") # Will be filled later
set(ZeroMQ_BUILD_MODULES_PATHS )

conan_find_apple_frameworks(ZeroMQ_FRAMEWORKS_FOUND "${ZeroMQ_FRAMEWORKS}" "${ZeroMQ_FRAMEWORK_DIRS}")

mark_as_advanced(ZeroMQ_INCLUDE_DIRS
                 ZeroMQ_INCLUDE_DIR
                 ZeroMQ_INCLUDES
                 ZeroMQ_DEFINITIONS
                 ZeroMQ_LINKER_FLAGS_LIST
                 ZeroMQ_COMPILE_DEFINITIONS
                 ZeroMQ_COMPILE_OPTIONS_LIST
                 ZeroMQ_LIBRARIES
                 ZeroMQ_LIBS
                 ZeroMQ_LIBRARIES_TARGETS)

# Find the real .lib/.a and add them to ZeroMQ_LIBS and ZeroMQ_LIBRARY_LIST
set(ZeroMQ_LIBRARY_LIST zmq)
set(ZeroMQ_LIB_DIRS "/home/ubuntu/.conan/data/zeromq/4.3.5/nemtech/stable/package/9428c85bc64cf85711c31a116b265ea0dd5903a4/lib")

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_ZeroMQ_DEPENDENCIES "${ZeroMQ_FRAMEWORKS_FOUND} ${ZeroMQ_SYSTEM_LIBS} ")

conan_package_library_targets("${ZeroMQ_LIBRARY_LIST}"  # libraries
                              "${ZeroMQ_LIB_DIRS}"      # package_libdir
                              "${_ZeroMQ_DEPENDENCIES}"  # deps
                              ZeroMQ_LIBRARIES            # out_libraries
                              ZeroMQ_LIBRARIES_TARGETS    # out_libraries_targets
                              ""                          # build_type
                              "ZeroMQ")                                      # package_name

set(ZeroMQ_LIBS ${ZeroMQ_LIBRARIES})

foreach(_FRAMEWORK ${ZeroMQ_FRAMEWORKS_FOUND})
    list(APPEND ZeroMQ_LIBRARIES_TARGETS ${_FRAMEWORK})
    list(APPEND ZeroMQ_LIBRARIES ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${ZeroMQ_SYSTEM_LIBS})
    list(APPEND ZeroMQ_LIBRARIES_TARGETS ${_SYSTEM_LIB})
    list(APPEND ZeroMQ_LIBRARIES ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(ZeroMQ_LIBRARIES_TARGETS "${ZeroMQ_LIBRARIES_TARGETS};")
set(ZeroMQ_LIBRARIES "${ZeroMQ_LIBRARIES};")

set(CMAKE_MODULE_PATH "/home/ubuntu/.conan/data/zeromq/4.3.5/nemtech/stable/package/9428c85bc64cf85711c31a116b265ea0dd5903a4/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/home/ubuntu/.conan/data/zeromq/4.3.5/nemtech/stable/package/9428c85bc64cf85711c31a116b265ea0dd5903a4/" ${CMAKE_PREFIX_PATH})

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    # Target approach
    if(NOT TARGET ZeroMQ::ZeroMQ)
        add_library(ZeroMQ::ZeroMQ INTERFACE IMPORTED)
        if(ZeroMQ_INCLUDE_DIRS)
            set_target_properties(ZeroMQ::ZeroMQ PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                                  "${ZeroMQ_INCLUDE_DIRS}")
        endif()
        set_property(TARGET ZeroMQ::ZeroMQ PROPERTY INTERFACE_LINK_LIBRARIES
                     "${ZeroMQ_LIBRARIES_TARGETS};${ZeroMQ_LINKER_FLAGS_LIST}")
        set_property(TARGET ZeroMQ::ZeroMQ PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     ${ZeroMQ_COMPILE_DEFINITIONS})
        set_property(TARGET ZeroMQ::ZeroMQ PROPERTY INTERFACE_COMPILE_OPTIONS
                     "${ZeroMQ_COMPILE_OPTIONS_LIST}")
        
    endif()
endif()

foreach(_BUILD_MODULE_PATH ${ZeroMQ_BUILD_MODULES_PATHS})
    include(${_BUILD_MODULE_PATH})
endforeach()
