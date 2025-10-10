#!/bin/bash

# Shell Test Runner for Pokehub
# Runs all Bats tests for shell scripts

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo -e "${BLUE}🧪 Pokehub Shell Test Suite${NC}"
echo "================================================"
echo ""

# Check if Bats is installed
if ! command -v bats &> /dev/null; then
    echo -e "${RED}❌ Bats is not installed!${NC}"
    echo ""
    echo "Install Bats:"
    echo "  macOS:   brew install bats-core"
    echo "  Linux:   npm install -g bats"
    echo ""
    exit 1
fi

echo -e "${GREEN}✅ Bats found:${NC} $(bats --version)"
echo ""

# Parse arguments
VERBOSE=false
SPECIFIC_TEST=""
QUIET=false
FILTER=""
LIST_ONLY=false
SHELL_ONLY=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -t|--test)
            SPECIFIC_TEST="$2"
            shift 2
            ;;
        -q|--quiet)
            QUIET=true
            shift
            ;;
        -f|--filter)
            FILTER="$2"
            shift 2
            ;;
        -l|--list)
            LIST_ONLY=true
            shift
            ;;
        --shell-only)
            SHELL_ONLY=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -v, --verbose       Show verbose output"
            echo "  -t, --test FILE     Run specific test file"
            echo "  -q, --quiet         Minimal output (only summary)"
            echo "  -f, --filter PATTERN  Run tests matching pattern"
            echo "  -l, --list          List all available tests"
            echo "  --shell-only        Exit code only (for integration with main test runner)"
            echo "  -h, --help          Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0                                      # Run all tests"
            echo "  $0 -v                                   # Run with verbose output"
            echo "  $0 -q                                   # Run with minimal output"
            echo "  $0 -t unit/deployment/test-deploy.bats  # Run specific test"
            echo "  $0 -f \"deploy\"                          # Run tests matching 'deploy'"
            echo "  $0 -l                                   # List all available tests"
            echo "  $0 --shell-only                         # Integration mode"
            echo ""
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

# Change to tests/shell directory
cd "$SCRIPT_DIR"

# Handle --list flag
if [ "$LIST_ONLY" = true ]; then
    echo -e "${BLUE}Available shell tests:${NC}"
    echo ""
    find unit/ -name "*.bats" -type f | sort | while read -r test_file; do
        echo "  $test_file"
        # Count tests in file
        test_count=$(grep -c "^@test" "$test_file" 2>/dev/null || echo "0")
        echo -e "    ${YELLOW}($test_count tests)${NC}"
    done
    echo ""
    total_files=$(find unit/ -name "*.bats" -type f | wc -l | tr -d ' ')
    total_tests=$(find unit/ -name "*.bats" -type f -print0 | xargs -0 grep -c "^@test" 2>/dev/null | awk -F: '{s+=$2} END {print s}')
    echo -e "${GREEN}Total:${NC} $total_files test files, $total_tests tests"
    exit 0
fi

# Adjust output for quiet or shell-only mode
if [ "$QUIET" = true ] || [ "$SHELL_ONLY" = true ]; then
    # Suppress header in quiet/shell-only mode
    :
fi

# Run tests
if [ -n "$SPECIFIC_TEST" ]; then
    if [ "$QUIET" = false ] && [ "$SHELL_ONLY" = false ]; then
        echo -e "${BLUE}Running specific test:${NC} $SPECIFIC_TEST"
        echo ""
    fi
    
    if [ "$VERBOSE" = true ]; then
        bats --verbose-run "$SPECIFIC_TEST"
    elif [ "$QUIET" = true ] || [ "$SHELL_ONLY" = true ]; then
        bats "$SPECIFIC_TEST" > /dev/null 2>&1
    else
        bats "$SPECIFIC_TEST"
    fi
    
    TEST_EXIT_CODE=$?
    
    if [ "$SHELL_ONLY" = true ]; then
        exit $TEST_EXIT_CODE
    fi
    
    if [ $TEST_EXIT_CODE -eq 0 ]; then
        if [ "$QUIET" = false ]; then
            echo ""
            echo -e "${GREEN}✅ Test passed!${NC}"
        fi
        exit 0
    else
        if [ "$QUIET" = false ]; then
            echo ""
            echo -e "${RED}❌ Test failed!${NC}"
        fi
        exit 1
    fi
    
elif [ -n "$FILTER" ]; then
    if [ "$QUIET" = false ] && [ "$SHELL_ONLY" = false ]; then
        echo -e "${BLUE}Running tests matching:${NC} $FILTER"
        echo ""
    fi
    
    # Track start time
    START_TIME=$(date +%s)
    
    if [ "$VERBOSE" = true ]; then
        bats --verbose-run --filter "$FILTER" --recursive unit/
    elif [ "$QUIET" = true ] || [ "$SHELL_ONLY" = true ]; then
        bats --filter "$FILTER" --recursive unit/ > /dev/null 2>&1
    else
        bats --filter "$FILTER" --recursive unit/
    fi
    
    TEST_EXIT_CODE=$?
    
    # Track end time
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))
    
    if [ "$SHELL_ONLY" = true ]; then
        exit $TEST_EXIT_CODE
    fi
    
    if [ $TEST_EXIT_CODE -eq 0 ]; then
        if [ "$QUIET" = false ]; then
            echo ""
            echo "================================================"
            echo -e "${GREEN}✅ Filtered tests passed!${NC}"
            echo -e "${BLUE}⏱️  Duration:${NC} ${DURATION}s"
            echo ""
        fi
        exit 0
    else
        if [ "$QUIET" = false ]; then
            echo ""
            echo "================================================"
            echo -e "${RED}❌ Some filtered tests failed!${NC}"
            echo -e "${BLUE}⏱️  Duration:${NC} ${DURATION}s"
            echo ""
        fi
        exit 1
    fi
    
else
    if [ "$QUIET" = false ] && [ "$SHELL_ONLY" = false ]; then
        echo -e "${BLUE}Running all shell tests...${NC}"
        echo ""
    fi
    
    # Track start time
    START_TIME=$(date +%s)
    
    if [ "$VERBOSE" = true ]; then
        bats --verbose-run --recursive unit/
    elif [ "$QUIET" = true ] || [ "$SHELL_ONLY" = true ]; then
        bats --recursive unit/ > /dev/null 2>&1
    else
        bats --recursive unit/
    fi
    
    TEST_EXIT_CODE=$?
    
    # Track end time
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))
    
    if [ "$SHELL_ONLY" = true ]; then
        exit $TEST_EXIT_CODE
    fi
    
    if [ $TEST_EXIT_CODE -eq 0 ]; then
        if [ "$QUIET" = false ]; then
            echo ""
            echo "================================================"
            echo -e "${GREEN}✅ All shell tests passed!${NC}"
            echo -e "${BLUE}⏱️  Duration:${NC} ${DURATION}s"
            echo ""
        fi
        exit 0
    else
        if [ "$QUIET" = false ]; then
            echo ""
            echo "================================================"
            echo -e "${RED}❌ Some shell tests failed!${NC}"
            echo -e "${BLUE}⏱️  Duration:${NC} ${DURATION}s"
            echo ""
        fi
        exit 1
    fi
fi
