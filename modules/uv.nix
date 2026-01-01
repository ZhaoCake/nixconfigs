{ pkgs, ... }:

{
  # uv 配置文件
  # 位于 ~/.config/uv/uv.toml
  xdg.configFile."uv/uv.toml".text = ''
    [[index]]
    url = "https://pypi.mirrors.ustc.edu.cn/simple"
    default = true
  '';
}
