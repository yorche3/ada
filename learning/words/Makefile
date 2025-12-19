# Variables
PROJECT_FILE = test.gpr
BUILD_DIR = obj
TEST_EXEC = run_tests

# Commands
GPRBUILD = gprbuild
RM = rm -rf
RMF = rm -f

.PHONY: all build run test clean

# Default target
all: build

# Build the project
build:
    @echo "Building project..."
    $(GPRBUILD) -p -P $(PROJECT_FILE)

# Run tests
run: build
    @if [ -f "./$(TEST_EXEC)" ]; then \
        echo "Running tests..."; \
        ./$(TEST_EXEC); \
    else \
        echo "Error: $(TEST_EXEC) not found."; \
        exit 1; \
    fi

# Clean build artifacts
clean:
    @echo "Cleaning build artifacts..."
    $(RM) $(BUILD_DIR)
    $(RMF) $(TEST_EXEC)