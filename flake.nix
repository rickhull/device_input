{
  description = "Provides a shell with ASDF version manager available";

  inputs = {
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils}:
    utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in {
          devShell = pkgs.mkShell {
            nativeBuildInputs = [ pkgs.bashInteractive ];
            buildInputs = [
	      pkgs.asdf-vm
            ];
          };
        }
      );
}
