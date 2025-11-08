# 开发环境模块说明
#
# 这个目录包含各种编程语言和开发环境的配置文件
# 
# 使用方法：
# 1. 在 home.nix 的 imports 部分添加需要的开发环境
# 2. 例如：imports = [ ./dev-envs/python.nix ];
#
# 可用的配置模块：
# - python.nix: Python 开发环境
# - nodejs.nix: Node.js 开发环境
# - rust.nix: Rust 开发环境
# - go.nix: Go 开发环境
#
# 您可以根据需要创建更多的开发环境配置文件
