{
  description = "Nix common config";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      hostPlatform = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${hostPlatform};
    in
    {
      legacyPackages.${hostPlatform} = pkgs;
      homeConfigurations."root" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
      };
    };
}
