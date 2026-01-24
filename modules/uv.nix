{ pkgs, ... }:

{
  # uv 配置文件
  # 位于 ~/.config/uv/uv.toml
  xdg.configFile."uv/uv.toml".text = ''
    [[index]]
    url = "https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple/"
    default = true
  '';
}
