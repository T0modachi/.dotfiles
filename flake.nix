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
    
    homeManagerConfigurations = {
      T0modachi = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
	  modules = [
	    ./users/T0modachi/home.nix
	  ];
      };

       jvergara-buk = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
	  modules = [
	    ./users/jvergara-buk/home.nix
	  ];
      };

    };


    nixosConfigurations = {
      # 'nixos' is the reference to the hostname of the machine, so you can have multiples
      nixos = lib.nixosSystem {
	inherit system;
        modules = [./system/configuration.nix];
      }; 

    };


  };
}
