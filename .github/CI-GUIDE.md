# GitHub Actions CI 配置

## 🔄 自动化工作流

本仓库配置了两个 GitHub Actions 工作流：

### 1. CI - Nix Configuration Check (`.github/workflows/ci.yml`)

**触发条件**: 
- Push 到 `main` 或 `master` 分支
- Pull Request

**检查内容**:
- ✅ Flake 结构验证
- ✅ Home Manager 配置构建
- ✅ 配置评估（无语法错误）
- ✅ 模块导入验证

### 2. Format Check (`.github/workflows/format.yml`)

**触发条件**: 
- Push 到 `main` 或 `master` 分支  
- Pull Request

**检查内容**:
- ✅ Nix 文件格式检查（使用 nixpkgs-fmt）

---

## 📝 本地测试命令

在推送前，可以在本地运行这些命令来提前发现问题：

### 检查配置构建

```bash
# 完整构建测试（推荐）
nix build .#homeConfigurations.cake.activationPackage --show-trace

# 快速语法检查
nix eval .#homeConfigurations.cake.config.home.username
```

### 检查代码格式

```bash
# 检查所有 Nix 文件
nixpkgs-fmt --check **/*.nix

# 自动格式化
nixpkgs-fmt **/*.nix
```

### 验证 Flake

```bash
# 检查 flake 结构
nix flake check

# 显示 flake 信息
nix flake show
nix flake metadata
```

---

## 🚀 设置 GitHub 仓库

1. **创建仓库**:
   ```bash
   cd ~/.nixconfigs
   git init
   git add .
   git commit -m "Initial commit"
   git branch -M main
   git remote add origin https://github.com/YOUR_USERNAME/nixconfigs.git
   git push -u origin main
   ```

2. **更新 README 徽章**:
   编辑 `README.md`，将 `YOUR_USERNAME` 替换为你的 GitHub 用户名。

3. **查看工作流状态**:
   访问 `https://github.com/YOUR_USERNAME/nixconfigs/actions`

---

## 🔧 可选：加速构建（使用 Cachix）

如果想加速 CI 构建，可以配置 Cachix：

1. 访问 https://cachix.org/ 并创建账户
2. 创建一个 cache
3. 在 GitHub 仓库设置中添加 Secret: `CACHIX_AUTH_TOKEN`
4. CI 会自动使用缓存

---

## ❌ CI 失败怎么办？

### 常见错误和解决方法

#### 1. 语法错误
```
error: syntax error, unexpected ...
```
**解决**: 检查对应文件的 Nix 语法，确保字符串、列表、属性集等格式正确。

#### 2. 模块导入失败
```
error: cannot coerce ...
```
**解决**: 检查 `home.nix` 中的 `imports` 列表，确保所有路径正确。

#### 3. 选项类型错误
```
error: A definition for option ... is not of type ...
```
**解决**: 检查配置选项的类型，参考 NixOS/home-manager 文档。

#### 4. 格式检查失败
```
❌ file.nix needs formatting
```
**解决**: 
```bash
nixpkgs-fmt file.nix
git add file.nix
git commit --amend --no-edit
git push --force-with-lease
```

---

## 📊 查看构建日志

1. 访问 GitHub Actions 页面
2. 点击失败的工作流
3. 展开失败的步骤查看详细日志
4. 使用 `--show-trace` 选项可以看到完整的错误堆栈

---

## 💡 最佳实践

1. **推送前本地测试**: 
   ```bash
   nix build .#homeConfigurations.cake.activationPackage
   ```

2. **使用小的提交**: 每次只修改一个模块，便于定位问题

3. **查看 CI 日志**: 即使本地测试通过，也要确认 CI 通过

4. **格式化代码**: 
   ```bash
   nixpkgs-fmt **/*.nix
   ```

5. **使用分支**: 在新分支上开发和测试，确认无误后再合并到 main
