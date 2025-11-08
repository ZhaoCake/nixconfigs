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
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      homeConfigurations = {
        cake = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          
          modules = [
            ./home.nix
            nixvim.homeModules.nixvim
          ];
          
          extraSpecialArgs = { inherit inputs; };
        };
      };
    };
}
