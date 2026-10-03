{
    description = "OpenHome packaged for NixOS";

    inputs =
    {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    outputs = { self, nixpkgs }:
    let
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
    in
    {
        packages.${system} =
        {
            openhome = pkgs.callPackage ./pkgs/openhome { };
            default = self.packages.${system}.openhome;
        };

        overlays.default = final: prev:
        {
            openhome = final.callPackage ./pkgs/openhome { };
        };
    };
}
