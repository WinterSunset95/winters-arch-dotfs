{
	description = "Autumn's Home Nix Setup";
	inputs = {
		self.submodules = true;
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		dms.url = "github:AvengeMedia/DankMaterialShell/stable";
	};

	outputs = { nixpkgs, home-manager, dms, ... }: {
		homeConfigurations."autumn" = home-manager.lib.homeManagerConfiguration {
			pkgs = nixpkgs.legacyPackages.x86_64-linux;
			modules = [
				./home.nix
				dms.homeModules.dank-material-shell
			];
		};
	};
}
