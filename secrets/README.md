# Secrets 加密管理

本目录存放通过 [agenix](https://github.com/ryantm/agenix) + [age](https://github.com/FiloSottile/age) 加密的 API 密钥文件。

## 加密机制

- **加密工具**: `age`，基于公钥加密（X25519）
- **密钥类型**: age 专用密钥（独立于 SSH 密钥）
- **密钥位置**: `~/.config/sops/age/keys.txt`（私钥）
- **公钥**: `age1rs5c6c7gt4ceunfjtap9fv7kdznj5fv732xp8xurc2ssfl4laafqxeg88c`
- **Nix 集成**: 通过 agenix home-manager 模块，`home-manager switch` 时自动用 `~/.config/sops/age/keys.txt` 解密到 `~/.config/ai-secrets/`

### 加密流程

```
原始密钥 → age encrypt -r <age公钥> → *.age 文件 → git 提交到仓库
                                              ↓
                         home-manager switch → agenix 自动解密 → ~/.config/ai-secrets/
```

### 当前加密文件

| 文件 | 用途 |
|------|------|
| `anthropic_api_key.age` | Anthropic / NewCLI Claude API Key |
| `chatanywhere_api_key.age` | ChatAnywhere API Key |
| `siliconflow_api_key.age` | SiliconFlow API Key |
| `deepseek_api_key.age` | DeepSeek API Key |
| `ark_api_key.age` | Ark (Volcengine) API Key |
| `tavily_api_key.age` | Tavily Search API Key |

## 日常操作

### 编辑密钥（自动解密 + 编辑 + 重新加密）

```bash
nix run github:ryantm/agenix -- -e secrets/anthropic_api_key.age
```

### 手动解密单个文件

```bash
age --decrypt -i ~/.config/sops/age/keys.txt secrets/anthropic_api_key.age
```

### 重新加密所有密钥（更换 recipient 后）

```bash
AGE_PUB="age1rs5c6c7gt4ceunfjtap9fv7kdznj5fv732xp8xurc2ssfl4laafqxeg88c"
for f in secrets/*.age; do
  plaintext=$(age --decrypt -i ~/.config/sops/age/keys.txt "$f")
  echo "$plaintext" | age --encrypt -r "$AGE_PUB" -o "$f"
done
```

## 在新机器上解密

只需要将 age 私钥复制到新机器即可：

```bash
# 在新机器上执行
mkdir -p ~/.config/sops/age
scp cake@<本机IP>:~/.config/sops/age/keys.txt ~/.config/sops/age/keys.txt
chmod 600 ~/.config/sops/age/keys.txt
```

之后运行 `home-manager switch` 即可自动解密。

### 添加新机器的公钥为额外 recipient

如果新机器有自己的 age 密钥且你不想共享私钥：

1. 在新机器上生成 age 密钥（如果没有的话）：
   ```bash
   mkdir -p ~/.config/sops/age
   age-keygen -o ~/.config/sops/age/keys.txt
   chmod 600 ~/.config/sops/age/keys.txt
   ```

2. 获取新机器的 age 公钥：
   ```bash
   age-keygen -y ~/.config/sops/age/keys.txt
   ```

3. 在本机用新旧两个公钥重新加密所有密钥：
   ```bash
   OLD_PUB="age1rs5c6c7gt4ceunfjtap9fv7kdznj5fv732xp8xurc2ssfl4laafqxeg88c"
   NEW_PUB="age1xxxx..."  # 新机器的 age 公钥

   for f in secrets/*.age; do
     plaintext=$(age --decrypt -i ~/.config/sops/age/keys.txt "$f")
     echo "$plaintext" | age --encrypt -r "$OLD_PUB" -r "$NEW_PUB" -o "$f"
   done
   ```

4. 提交更新后的 `.age` 文件，新机器也添加 `age.identityPaths` 指向其自己的 `keys.txt`。

## 安全注意事项

- `.age` 文件可以安全提交到 Git 公开仓库（只有拥有对应私钥的人才能解密）
- **永远不要**将 `~/.config/sops/age/keys.txt`（私钥）提交到 Git
- **永远不要**将解密后的明文密钥提交到 Git
- `~/.config/sops/age/` 和 `~/.config/ai-secrets/` 已在 `.gitignore` 中排除
- 更换 age 密钥后，务必用新公钥重新加密所有 `.age` 文件
