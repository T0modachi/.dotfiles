{
  description = "T0modachi's System Config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs"; 
  };

  outputs = { nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {allowUnfree = true;};
    };
    lib = nixpkgs.lib;
  in  {
    nixosConfigurations = {
      # 'nixos' is the reference to the hostname of the machine, so you can have multiples
      nixos = lib.nixosSystem {
	inherit system;
        modules = [./system/configuration.nix];
      }; 

    };


  };
}
