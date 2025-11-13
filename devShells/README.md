# 开发环境 (Development Shells)

## 设计理念

为了避免全局包冲突，所有开发环境都使用 **按需激活** 的方式：

- 每个开发环境是独立的 Nix flake
- 通过 `direnv` 在进入项目目录时自动激活
- 不同项目的依赖完全隔离，互不影响
- 可以同时维护多个不同版本的工具链

## 使用方法

### 快速创建项目（推荐）

使用 `nix-init` 函数快速创建项目：

```bash
# 创建新项目
nix-init sv my-counter              # SystemVerilog 项目
nix-init bsv my-processor           # Bluespec 项目  
nix-init chisel ~/projects/riscv    # Chisel 项目

# 在当前目录初始化
mkdir my-project && cd my-project
nix-init sv                          # 在当前目录初始化

# 环境会自动激活（通过 direnv）
make help                            # 查看可用命令
```

### 手动复制模板

如果不使用 `nix-init`：

```bash
# 复制模板
cp -r ~/.nixconfigs/devShells/systemverilog ~/projects/my-sv-project
cd ~/projects/my-sv-project

# 激活环境
direnv allow
```

### 进入已有项目

如果项目已有 `flake.nix` 和 `.envrc`：

```bash
cd ~/projects/my-project
direnv allow  # 首次需要授权
# 环境会自动激活，所有依赖都可用
```

### 手动激活环境

不使用 direnv 的情况：

```bash
nix develop  # 使用项目的 flake.nix
```

## 可用的开发环境

| 环境 | 目录 | 包含工具 | 说明 |
|------|------|----------|------|
| SystemVerilog | `systemverilog/` | verilator, gtkwave, verible | 完整项目模板 |
| BSV | `bsv/` | bluespec, verilator, iverilog, gtkwave | 完整项目模板 |
| Chisel | `chisel/` | mill, scala, sbt, verilator, gtkwave | 完整项目模板 |

**注意**：Rust、C/C++、Python 等通用开发工具已在全局安装（通过 `home.nix`），不需要单独的 devShell。

## 自定义开发环境

### 基础模板

创建 `flake.nix`：

```nix
{
  description = "我的开发环境";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          # 在这里添加你需要的包
          git
          curl
        ];
        
        shellHook = ''
          echo "🚀 开发环境已激活"
        '';
      };
    };
}
```

创建 `.envrc`：

```bash
use flake
```

然后运行 `direnv allow`。

## 优势

✅ **隔离性**：每个项目的依赖互不影响  
✅ **可重现**：flake.lock 锁定所有依赖版本  
✅ **便捷性**：direnv 自动激活，无需手动切换  
✅ **灵活性**：可以为不同项目使用不同版本的工具  
✅ **整洁性**：全局环境保持简洁，只安装通用工具  

## 全局 vs 项目环境

### 全局安装（home.nix）
- 基础工具：git, curl, wget, ssh
- 编辑器：neovim (nixvim)
- Shell：fish, starship
- 终端工具：tmux, alacritty, ripgrep, fd, bat

### 项目环境（devShells）
- 编程语言工具链
- 构建工具
- 调试器
- 特定版本的依赖

## 故障排除

### direnv 未自动激活
```bash
# 检查 direnv 状态
direnv status

# 重新加载
direnv reload
```

### flake 更新
```bash
# 更新 flake.lock
nix flake update

# 重建环境
direnv reload
```

### 清理未使用的环境
```bash
# 垃圾回收
nix-collect-garbage -d
```

## 参考资料

- [Nix Flakes](https://nixos.wiki/wiki/Flakes)
- [direnv](https://direnv.net/)
- [nix develop](https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-develop.html)
