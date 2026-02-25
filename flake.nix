{
  description = "Personal Nix development environment configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixvim, ... }@inputs:
    let
      system = "x86_64-linux";
      # 辅助函数：构建 pkgs
      mkPkgs = system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      # ==========================================
      # 场景 1: 非 NixOS Linux (Ubuntu, WSL, Arch 等)
      # ==========================================
      # 使用命令: home-manager switch --flake .#cake
      homeConfigurations = {
        cake = home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs system;
          
          modules = [
            ./home.nix
            nixvim.homeModules.nixvim
          ];
          
          extraSpecialArgs = { inherit inputs; };
        };
      };

      # ==========================================
      # 场景 2: NixOS 虚拟机
      # ==========================================
      # 使用命令: sudo nixos-rebuild switch --flake .#nixos
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          
          modules = [
            # 1. 导入这台机器特有的配置
            ./hosts/nixos-vm/configuration.nix

            # 2. 将 Home Manager 作为 NixOS 模块加载
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              
              # 复用根目录下的 home.nix
              home-manager.users.cake = {
                imports = [
                  ./home.nix
                  nixvim.homeModules.nixvim
                ];
              };

              # 传递 inputs 给 home.nix
              home-manager.extraSpecialArgs = { inherit inputs; };
            }
          ];
        };

      # ==========================================
      # 场景 3: Matebook 笔记本
      # ==========================================
      # 使用命令: sudo nixos-rebuild switch --flake .#matebook
        matebook = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          
          modules = [
            # 1. 导入这台机器特有的配置
            ./hosts/matebook/configuration.nix

            # 2. 将 Home Manager 作为 NixOS 模块加载
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              
              # 复用根目录下的 home.nix
              home-manager.users.cake = {
                imports = [
                  ./home.nix
                  nixvim.homeModules.nixvim
                ];
              };

              # 传递 inputs 给 home.nix
              home-manager.extraSpecialArgs = { inherit inputs; };
            }
          ];
        };
      };
    };
}
