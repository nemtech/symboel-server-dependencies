

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

conan_message(STATUS "Conan: Using autogenerated Findcppzmq.cmake")
# Global approach
set(cppzmq_FOUND 1)
set(cppzmq_VERSION "4.10.0")

find_package_handle_standard_args(cppzmq REQUIRED_VARS
                                  cppzmq_VERSION VERSION_VAR cppzmq_VERSION)
mark_as_advanced(cppzmq_FOUND cppzmq_VERSION)


set(cppzmq_INCLUDE_DIRS "/home/ubuntu/.conan/data/cppzmq/4.10.0/nemtech/stable/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/include")
set(cppzmq_INCLUDE_DIR "/home/ubuntu/.conan/data/cppzmq/4.10.0/nemtech/stable/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/include")
set(cppzmq_INCLUDES "/home/ubuntu/.conan/data/cppzmq/4.10.0/nemtech/stable/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/include")
set(cppzmq_RES_DIRS )
set(cppzmq_DEFINITIONS )
set(cppzmq_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(cppzmq_COMPILE_DEFINITIONS )
set(cppzmq_COMPILE_OPTIONS_LIST "" "")
set(cppzmq_COMPILE_OPTIONS_C "")
set(cppzmq_COMPILE_OPTIONS_CXX "")
set(cppzmq_LIBRARIES_TARGETS "") # Will be filled later, if CMake 3
set(cppzmq_LIBRARIES "") # Will be filled later
set(cppzmq_LIBS "") # Same as cppzmq_LIBRARIES
set(cppzmq_SYSTEM_LIBS )
set(cppzmq_FRAMEWORK_DIRS )
set(cppzmq_FRAMEWORKS )
set(cppzmq_FRAMEWORKS_FOUND "") # Will be filled later
set(cppzmq_BUILD_MODULES_PATHS )

conan_find_apple_frameworks(cppzmq_FRAMEWORKS_FOUND "${cppzmq_FRAMEWORKS}" "${cppzmq_FRAMEWORK_DIRS}")

mark_as_advanced(cppzmq_INCLUDE_DIRS
                 cppzmq_INCLUDE_DIR
                 cppzmq_INCLUDES
                 cppzmq_DEFINITIONS
                 cppzmq_LINKER_FLAGS_LIST
                 cppzmq_COMPILE_DEFINITIONS
                 cppzmq_COMPILE_OPTIONS_LIST
                 cppzmq_LIBRARIES
                 cppzmq_LIBS
                 cppzmq_LIBRARIES_TARGETS)

# Find the real .lib/.a and add them to cppzmq_LIBS and cppzmq_LIBRARY_LIST
set(cppzmq_LIBRARY_LIST )
set(cppzmq_LIB_DIRS "/home/ubuntu/.conan/data/cppzmq/4.10.0/nemtech/stable/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/lib")

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_cppzmq_DEPENDENCIES "${cppzmq_FRAMEWORKS_FOUND} ${cppzmq_SYSTEM_LIBS} ZeroMQ::ZeroMQ")

conan_package_library_targets("${cppzmq_LIBRARY_LIST}"  # libraries
                              "${cppzmq_LIB_DIRS}"      # package_libdir
                              "${_cppzmq_DEPENDENCIES}"  # deps
                              cppzmq_LIBRARIES            # out_libraries
                              cppzmq_LIBRARIES_TARGETS    # out_libraries_targets
                              ""                          # build_type
                              "cppzmq")                                      # package_name

set(cppzmq_LIBS ${cppzmq_LIBRARIES})

foreach(_FRAMEWORK ${cppzmq_FRAMEWORKS_FOUND})
    list(APPEND cppzmq_LIBRARIES_TARGETS ${_FRAMEWORK})
    list(APPEND cppzmq_LIBRARIES ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${cppzmq_SYSTEM_LIBS})
    list(APPEND cppzmq_LIBRARIES_TARGETS ${_SYSTEM_LIB})
    list(APPEND cppzmq_LIBRARIES ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(cppzmq_LIBRARIES_TARGETS "${cppzmq_LIBRARIES_TARGETS};ZeroMQ::ZeroMQ")
set(cppzmq_LIBRARIES "${cppzmq_LIBRARIES};ZeroMQ::ZeroMQ")

set(CMAKE_MODULE_PATH "/home/ubuntu/.conan/data/cppzmq/4.10.0/nemtech/stable/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/home/ubuntu/.conan/data/cppzmq/4.10.0/nemtech/stable/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/" ${CMAKE_PREFIX_PATH})

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    # Target approach
    if(NOT TARGET cppzmq::cppzmq)
        add_library(cppzmq::cppzmq INTERFACE IMPORTED)
        if(cppzmq_INCLUDE_DIRS)
            set_target_properties(cppzmq::cppzmq PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                                  "${cppzmq_INCLUDE_DIRS}")
        endif()
        set_property(TARGET cppzmq::cppzmq PROPERTY INTERFACE_LINK_LIBRARIES
                     "${cppzmq_LIBRARIES_TARGETS};${cppzmq_LINKER_FLAGS_LIST}")
        set_property(TARGET cppzmq::cppzmq PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     ${cppzmq_COMPILE_DEFINITIONS})
        set_property(TARGET cppzmq::cppzmq PROPERTY INTERFACE_COMPILE_OPTIONS
                     "${cppzmq_COMPILE_OPTIONS_LIST}")
        
        # Library dependencies
        include(CMakeFindDependencyMacro)

        if(NOT ZeroMQ_FOUND)
            find_dependency(ZeroMQ REQUIRED)
        else()
            message(STATUS "Dependency ZeroMQ already found")
        endif()

    endif()
endif()

foreach(_BUILD_MODULE_PATH ${cppzmq_BUILD_MODULES_PATHS})
    include(${_BUILD_MODULE_PATH})
endforeach()
