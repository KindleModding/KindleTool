{
  inputs.nixpkgs.url = "github:nixos/nixpkgs";

  outputs =
    { nixpkgs, ... }:
    let
      kindletool = import ./package.nix;

      overlays.default = final: _: {
        kindletool = final.callPackage kindletool { };
      };

      forEachSystem = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      packages = forEachSystem (system: {
        default = nixpkgs.legacyPackages.${system}.callPackage kindletool { };
      });

      devShells = forEachSystem (system: {
        default = nixpkgs.legacyPackages.${system}.mkShell { packages = [ packages.${system}.default ]; };
      });
    in
    {
      inherit overlays packages devShells;
    };
}
