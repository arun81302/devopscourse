#!/bin/bash

# Setup Verification Script
# This script checks if everything is set up correctly

echo "🔍 Full Stack Docker App - Setup Verification"
echo "=============================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check functions
check_pass() {
    echo -e "${GREEN}✓${NC} $1"
}

check_fail() {
    echo -e "${RED}✗${NC} $1"
}

check_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Check Docker
echo "1. Checking Docker..."
if command -v docker &> /dev/null; then
    check_pass "Docker is installed"
    docker --version
else
    check_fail "Docker is NOT installed"
    echo "   Install from: https://docs.docker.com/get-docker/"
fi
echo ""

# Check Docker Compose
echo "2. Checking Docker Compose..."
if command -v docker-compose &> /dev/null; then
    check_pass "Docker Compose is installed"
    docker-compose --version
else
    check_fail "Docker Compose is NOT installed"
fi
echo ""

# Check Docker daemon
echo "3. Checking Docker daemon..."
if docker info &> /dev/null; then
    check_pass "Docker daemon is running"
else
    check_fail "Docker daemon is NOT running"
    echo "   Start Docker Desktop or run: sudo systemctl start docker"
fi
echo ""

# Check project structure
echo "4. Checking project structure..."
required_files=(
    "docker-compose.yaml"
    "frontend/Dockerfile"
    "frontend/package.json"
    "frontend/server.js"
    "frontend/public/index.html"
    "backend/Dockerfile"
    "backend/requirements.txt"
    "backend/app.py"
    ".gitignore"
)

all_files_present=true
for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        check_pass "$file exists"
    else
        check_fail "$file is missing"
        all_files_present=false
    fi
done
echo ""

# Check .gitignore
echo "5. Checking .gitignore..."
if grep -q "node_modules" .gitignore; then
    check_pass "node_modules is ignored"
else
    check_warn "node_modules not in .gitignore"
fi

if grep -q ".vscode" .gitignore; then
    check_pass ".vscode is ignored"
else
    check_warn ".vscode not in .gitignore"
fi

if grep -q "__pycache__" .gitignore; then
    check_pass "__pycache__ is ignored"
else
    check_warn "__pycache__ not in .gitignore"
fi
echo ""

# Check ports
echo "6. Checking if ports are available..."
if lsof -Pi :3000 -sTCP:LISTEN -t &> /dev/null; then
    check_warn "Port 3000 is in use"
    echo "   Kill process: lsof -ti:3000 | xargs kill -9"
else
    check_pass "Port 3000 is available"
fi

if lsof -Pi :5000 -sTCP:LISTEN -t &> /dev/null; then
    check_warn "Port 5000 is in use"
    echo "   Kill process: lsof -ti:5000 | xargs kill -9"
else
    check_pass "Port 5000 is available"
fi
echo ""

# Check Git
echo "7. Checking Git..."
if command -v git &> /dev/null; then
    check_pass "Git is installed"
    git --version
    
    if [ -d .git ]; then
        check_pass "Git repository initialized"
    else
        check_warn "Git repository not initialized"
        echo "   Run: git init"
    fi
else
    check_warn "Git is not installed"
fi
echo ""

# Summary
echo "=============================================="
echo "📊 Summary"
echo "=============================================="

if $all_files_present && command -v docker &> /dev/null && command -v docker-compose &> /dev/null && docker info &> /dev/null; then
    echo -e "${GREEN}✓ All checks passed!${NC}"
    echo ""
    echo "🚀 You're ready to start! Run:"
    echo "   docker-compose up --build"
else
    echo -e "${RED}✗ Some checks failed${NC}"
    echo "Please fix the issues above before proceeding."
fi

echo ""
echo "📚 For detailed instructions, see:"
echo "   - README.md"
echo "   - QUICKSTART.md"
echo "   - PROJECT_SUMMARY.md"
