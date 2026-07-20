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
    catppuccin.url = "github:catppuccin/nix";
	};
	outputs = { self, nixpkgs, home-manager, dms, nixcord, catppuccin, ... }@inputs: {
		nixosConfigurations."trix"  = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
      specialArgs = { inherit inputs; };
			modules = [
				./system/hardware-configuration.nix
				./system/configuration.nix
			];
		};

    homeConfigurations."autumn" = home-manager.lib.homeManagerConfiguration {
			pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
      extraSpecialArgs = { inherit inputs; };
      modules = [
        ./user/home.nix
        dms.homeModules.dank-material-shell
        nixcord.homeModules.nixcord
        catppuccin.homeModules.catppuccin
      ];
    };
		
	};
}
