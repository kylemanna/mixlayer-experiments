{
  description = "Dev shell with Node.js and modelsocket";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.nodejs
          ];

          shellHook = ''
            echo "Setting up development environment..."
            export MODELSOCKET_API_KEY=$(${pkgs.libsecret}/bin/secret-tool lookup api mixlayer)
            npm install modelsocket
            echo "modelsocket installed successfully!"
          '';
        };

        packages.default = pkgs.buildNpmPackage {
          pname = "mixlayer-quickstart";
          version = "0.1.0";
          src = ./.;

          npmDepsHash = "sha256-nMR+AVWiO9ETxYdFa4tLNMVDPkQebJdTnmA9R8b0uQQ=";

          dontNpmBuild = true;

          installPhase = ''
            runHook preInstall

            mkdir -p $out/bin
            cp -r node_modules index.mjs $out/bin/

            runHook postInstall

            cat > $out/bin/mixlayer-quickstart << EOF
            #!/bin/sh
            export MODELSOCKET_API_KEY=\$(${pkgs.libsecret}/bin/secret-tool lookup api mixlayer)
            cd $out/bin
            exec ${pkgs.nodejs}/bin/node index.mjs "\$@"
            EOF
            chmod +x $out/bin/mixlayer-quickstart
          '';
        };

        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/mixlayer-quickstart";
        };
      }
    );
}
