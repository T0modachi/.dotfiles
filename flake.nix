{
  description = "dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    devenv.url = "github:cachix/devenv/latest";
    nixvim.url = "github:T0modachi/nixvim-config";
    llm-agents.url = "github:numtide/llm-agents.nix";
    mcp-servers-nix.url = "github:natsukium/mcp-servers-nix";
    agent-skills-nix.url = "github:Kyure-A/agent-skills-nix";
    zen-browser-flake.url = "github:0xc000022070/zen-browser-flake";
    caveman = {
      url = "github:JuliusBrussee/caveman";
      flake = false;
    };
    anthropic-skills = {
      url = "github:anthropics/skills";
      flake = false;
    };
    ponytail = {
      url = "github:DietrichGebert/ponytail";
      flake = false;
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
            inputs.agent-skills-nix.homeManagerModules.default
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
