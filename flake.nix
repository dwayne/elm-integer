{
  description = "A developer shell for working on elm-integer.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=23.05";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";

      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        name = "elm-integer";

        packages = with pkgs.elmPackages; [
          elm
          elm-doc-preview
          elm-format
          elm-optimize-level-2
          elm-test
        ];

        shellHook =
          ''
          export project="$PWD"
          export PATH="$project/bin:$PATH"
          '';
      };
    };
}
