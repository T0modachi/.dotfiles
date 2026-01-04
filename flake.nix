{
  description = "jvergara-ialink dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    devenv.url = "github:cachix/devenv/latest";
    nixvim.url = "github:T0modachi/nixvim-config";
    quickshell = {
      url = "github:outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.quickshell.follows = "quickshell"; # Use same quickshell version
    };
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
            ./users/T0modachi/home.nix
          ];
          extraSpecialArgs = { inherit inputs outputs; };
        };

        jvergara-ialink = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./users/jvergara-ialink/home.nix
          ];
          extraSpecialArgs = { inherit inputs outputs; };
        };
      };

      nixosConfigurations = {
        work-laptop = lib.nixosSystem {
          inherit system;
          modules = [
            ./system/work-laptop/configuration.nix
            ./system/work-laptop/hardware-configuration.nix
          ];
        };
        nix-laptop = lib.nixosSystem {
          inherit system;
          modules = [
            ./system/nix-laptop/configuration.nix
            ./system/nix-laptop/hardware-configuration.nix
            ./noctalia/noctalia.nix
          ];
        };
      };
    };
}
