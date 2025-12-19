cmake_minimum_required(VERSION 3.10)

project(AdaProject LANGUAGES Ada)

# Set the main project file
set(PROJECT_FILE "test.gpr")
set(TEST_EXEC "run_tests")

# Add custom target to run gprbuild
add_custom_target(build_project
    COMMAND gprbuild -p -P ${PROJECT_FILE}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Building project with gprbuild..."
)

# Add custom target to run tests
add_custom_target(run_tests
    COMMAND ${CMAKE_SOURCE_DIR}/${TEST_EXEC}
    DEPENDS build_project
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Running tests..."
)

# Add custom target for cleanup
add_custom_target(cleanup
    COMMAND ${CMAKE_COMMAND} -E remove_directory obj
    COMMAND ${CMAKE_COMMAND} -E remove ${TEST_EXEC}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Cleaning build artifacts..."
)