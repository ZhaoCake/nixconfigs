#!/usr/bin/env bash
# devShells 集成测试脚本
# 测试所有开发环境的 flake 可以正常构建和激活

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
DEVSHELLS_DIR="$REPO_ROOT/devShells"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 计数器
TOTAL=0
PASSED=0
FAILED=0

echo "🧪 Testing devShells configurations..."
echo "========================================"
echo ""

# 测试单个 devShell
test_devshell() {
    local env_name=$1
    local env_dir="$DEVSHELLS_DIR/$env_name"
    
    TOTAL=$((TOTAL + 1))
    echo -n "Testing $env_name... "
    
    if [ ! -d "$env_dir" ]; then
        echo -e "${RED}✗ Directory not found${NC}"
        FAILED=$((FAILED + 1))
        return 1
    fi
    
    if [ ! -f "$env_dir/flake.nix" ]; then
        echo -e "${RED}✗ flake.nix not found${NC}"
        FAILED=$((FAILED + 1))
        return 1
    fi
    
    # 测试 flake 检查
    if ! nix flake check "$env_dir" --no-build 2>/dev/null; then
        echo -e "${RED}✗ Flake check failed${NC}"
        FAILED=$((FAILED + 1))
        return 1
    fi
    
    # 测试 devShell 构建
    if ! nix build "$env_dir#devShells.x86_64-linux.default" --no-link 2>&1 | grep -q ""; then
        # 实际测试构建
        if ! nix build "$env_dir#devShells.x86_64-linux.default" --no-link &>/dev/null; then
            echo -e "${RED}✗ Build failed${NC}"
            FAILED=$((FAILED + 1))
            return 1
        fi
    fi
    
    # 测试能否进入 shell
    if ! nix develop "$env_dir" --command echo "Shell activated" &>/dev/null; then
        echo -e "${RED}✗ Shell activation failed${NC}"
        FAILED=$((FAILED + 1))
        return 1
    fi
    
    echo -e "${GREEN}✓ Passed${NC}"
    PASSED=$((PASSED + 1))
    return 0
}

# 测试所有 devShells
ENV_LIST=(
    "rust"
    "cpp"
    "python"
    "systemverilog"
    "bsv"
    "chisel"
)

echo "Found ${#ENV_LIST[@]} devShell environments to test"
echo ""

for env in "${ENV_LIST[@]}"; do
    test_devshell "$env"
done

echo ""
echo "========================================"
echo "📊 Test Results:"
echo "   Total:  $TOTAL"
echo -e "   ${GREEN}Passed: $PASSED${NC}"
if [ $FAILED -gt 0 ]; then
    echo -e "   ${RED}Failed: $FAILED${NC}"
else
    echo "   Failed: 0"
fi
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✨ All devShells tests passed!${NC}"
    exit 0
else
    echo -e "${RED}❌ Some tests failed${NC}"
    exit 1
fi
