{
	description = "Trix system architecture";
	inputs = {
    self.submodules = true;
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		dms = { 
      url = "github:AvengeMedia/DankMaterialShell/stable"; 
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixcord = {
      url = "github:kaylorben/nixcord";
    };
	};
	outputs = { self, nixpkgs, home-manager, dms, nixcord, ... }@inputs: {
		nixosConfigurations."trix"  = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
      specialArgs = { inherit inputs; };
			modules = [
				./system/hardware-configuration.nix
				./system/configuration.nix
			];
		};

    homeConfigurations."autumn" = home-manager.lib.homeManagerConfiguration {
			pkgs = nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = { inherit inputs; };
      modules = [
        ./user/home.nix
        dms.homeModules.dank-material-shell
        nixcord.homeManagerModules.nixcord
      ];
    };
		
	};
}
