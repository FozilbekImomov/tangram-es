# options
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -std=c++1y")

add_definitions(-DPLATFORM_LINUX)

# load glfw
include(${PROJECT_SOURCE_DIR}/toolchains/add_glfw.cmake)

# load core library
add_subdirectory(${PROJECT_SOURCE_DIR}/core)
include_directories(${CORE_INCLUDE_DIRS})
include_directories(${CORE_LIBRARIES_INCLUDE_DIRS})


set(LINUX_PLATFORM_SRC
  ${PROJECT_SOURCE_DIR}/linux/src/platform_linux.cpp
  ${PROJECT_SOURCE_DIR}/linux/src/urlWorker.cpp
)

file(GLOB BENCH_SOURCES bench/*.cpp)

# create an executable per test
foreach(_src_file_path ${BENCH_SOURCES})
    string(REPLACE ".cpp" "" bench ${_src_file_path})
    string(REGEX MATCH "([^/]*)$" bench_name ${bench})

    set(EXECUTABLE_NAME "${bench_name}.out")

    add_executable(${EXECUTABLE_NAME} ${_src_file_path} ${LINUX_PLATFORM_SRC})

    target_link_libraries(${EXECUTABLE_NAME} benchmark core -lcurl glfw ${GLFW_LIBRARIES})
endforeach(_src_file_path ${BENCH_SOURCES})

# copy resources in order to make tests with resources dependency
file(GLOB_RECURSE RESOURCES ${PROJECT_SOURCE_DIR}/core/resources/*)
foreach(_resource ${RESOURCES})
    file(COPY ${_resource} DESTINATION ${PROJECT_SOURCE_DIR}/build/bench/bin)
endforeach()