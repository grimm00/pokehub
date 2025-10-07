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
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -v, --verbose     Show verbose output"
            echo "  -t, --test FILE   Run specific test file"
            echo "  -h, --help        Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0                                    # Run all tests"
            echo "  $0 -v                                 # Run with verbose output"
            echo "  $0 -t unit/deployment/test-deploy.bats  # Run specific test"
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

# Run tests
if [ -n "$SPECIFIC_TEST" ]; then
    echo -e "${BLUE}Running specific test:${NC} $SPECIFIC_TEST"
    echo ""
    
    if [ "$VERBOSE" = true ]; then
        bats --verbose-run "$SPECIFIC_TEST"
    else
        bats "$SPECIFIC_TEST"
    fi
else
    echo -e "${BLUE}Running all shell tests...${NC}"
    echo ""
    
    # Track start time
    START_TIME=$(date +%s)
    
    if [ "$VERBOSE" = true ]; then
        bats --verbose-run --recursive unit/
    else
        bats --recursive unit/
    fi
    
    # Track end time
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))
    
    echo ""
    echo "================================================"
    echo -e "${GREEN}✅ All shell tests passed!${NC}"
    echo -e "${BLUE}⏱️  Duration:${NC} ${DURATION}s"
    echo ""
fi
