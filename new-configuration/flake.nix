{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xmonad-contrib.url = github:xmonad/xmonad-contrib;
  };

  outputs = { self, nixpkgs, xmonad-contrib, ... }@inputs: {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        {
          nixpkgs.config.allowUnfree = true;
        }
        ./configuration.nix
        inputs.home-manager.nixosModules.default
      ];
    };
  };
}
