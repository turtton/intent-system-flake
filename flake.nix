{
  description = "intent-system / intent-cli - Nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    intent-system = {
      url = "github:J-Tech-Japan/intent-system";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, intent-system }:
    let
      # Read the upstream version policy so the package version tracks the
      # source instead of a hard-coded literal.
      upstreamVersion =
        (builtins.fromJSON (builtins.readFile "${intent-system}/eng/version.json")).nextVersion;

      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forEachSystem = f:
        nixpkgs.lib.genAttrs supportedSystems (system:
          f {
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = false;
            };
          });
    in
    {
      packages = forEachSystem ({ pkgs }:
        let
          pkg = pkgs.callPackage ./intent-system.nix {
            src = intent-system;
            version = upstreamVersion;
          };
        in
        {
          default = pkg;
          intent-cli = pkg;
        });

      devShells = forEachSystem ({ pkgs }: {
        default = pkgs.mkShell {
          name = "intent-system-shell";
          packages = with pkgs; [
            dotnet-sdk_10
            git
            zizmor
            pinact
          ];
        };
      });

      apps = forEachSystem ({ pkgs }:
        let
          program = "${self.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/intent-cli";
        in
        {
          default = {
            type = "app";
            inherit program;
            meta = {
              description = "Run intent-cli from the Nix flake";
              mainProgram = "intent-cli";
            };
          };
          intent-cli = self.apps.${pkgs.stdenv.hostPlatform.system}.default;
        });

      checks = forEachSystem ({ pkgs }:
        let
          pkg = self.packages.${pkgs.stdenv.hostPlatform.system}.default;
        in
        {
          default = pkgs.runCommand "intent-cli-smoke-test"
            {
              nativeBuildInputs = [ pkg ];
            }
            ''
              actual=$(intent-cli --version)
              expected="intent-cli ${upstreamVersion}"
              if [ "$actual" != "$expected" ]; then
                echo "Smoke test failed: expected '$expected', got '$actual'" >&2
                exit 1
              fi
              printf '%s\n' "$actual" > "$out"
            '';
        });

      formatter = forEachSystem ({ pkgs }: pkgs.nixpkgs-fmt);
    };
}
