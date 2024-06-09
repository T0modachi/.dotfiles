{
  description = "T0modachi's System Config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs"; 
    devenv.url = "github:cachix/devenv/latest";
  };

  outputs = { 
    self,
    nixpkgs, 
    home-manager, 
    ... } @ inputs: let
    inherit (self) outputs;

    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {allowUnfree = true; allowUnfreePredicate = (_: true);};
    };
    lib = nixpkgs.lib;
  in  {
    
    homeManagerConfigurations = {
      T0modachi = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
	    inherit system;
	    config.allowUnfree = true;
      config.allowUnfreePredicate = (_: true);
      config.permittedInsecurePackages = [ "electron-25.9.0" ];
	  };
	  modules = [
	    ./users/T0modachi/home.nix
	  ];
    extraSpecialArgs = {inherit inputs outputs;};
      };

       jvergara-buk = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
	    inherit system;
	    config.allowUnfree = true;
      config.allowUnfreePredicate = (_: true);
      config.permittedInsecurePackages = [ "electron-25.9.0" "openssl-1.1.1w" ];
	  };
	  modules = [
	    ./users/jvergara-buk/home.nix
	  ];
    extraSpecialArgs = {inherit inputs outputs;};
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
