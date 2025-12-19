#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

PROJECT_FILE="test.gpr"
BUILD_DIR="obj/test"
TEST_EXEC="run_tests"

echo "Creating build directory..."
mkdir -p "$BUILD_DIR"

echo "Building project..."
gprbuild -p -P "$PROJECT_FILE"

if [ -f "./$TEST_EXEC" ]; then
    echo "Running tests..."
    "./$TEST_EXEC"
else
    echo "Error: $TEST_EXEC not found."
    exit 1
fi

# Cleanup
echo "Cleaning build artifacts..."
rm -rf "$BUILD_DIR"
rm -f "$TEST_EXEC"

echo "Done."