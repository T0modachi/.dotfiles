{
  description = "dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    devenv.url = "github:cachix/devenv/latest";
    nixvim.url = "github:T0modachi/nixvim-config";
    my-omp.url = "github:T0modachi/my-omp";
    zen-browser-flake.url = "github:0xc000022070/zen-browser-flake";
    noctalia.url = "github:noctalia-dev/noctalia/cachix";
    niri.url = "github:sodiboo/niri-flake";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = _: true;
          permittedInsecurePackages = [
            "electron-25.9.0"
            "electron-27.3.11"
            "electron-28.3.3"
            "electron-39.8.10"
          ];
        };
      };

      inherit (nixpkgs) lib;
    in
    {
      homeManagerConfigurations = {
        T0modachi = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home
            inputs.my-omp.homeManagerModules.default
            inputs.noctalia.homeModules.default
            inputs.niri.homeModules.config
          ];
          extraSpecialArgs = { inherit inputs outputs; };
        };
      };

      nixosConfigurations = {
        nix-laptop = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./system
          ];
        };
      };
    };
}
