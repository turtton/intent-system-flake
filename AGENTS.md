# Agent Notes

This repository is a standalone Nix flake that packages the upstream [`J-Tech-Japan/intent-system`](https://github.com/J-Tech-Japan/intent-system) CLI (`intent-cli`). It does **not** contain the application source code.

## Verification

```bash
nix flake check
```

This builds the package and runs the smoke test.

## Common tasks

- **Run the tool**: `nix run . -- --version`
- **Build**: `nix build .` → `./result/bin/intent-cli`
- **Dev shell**: `nix develop .` (provides `dotnet-sdk_10` and `git`)
- **Format Nix**: `nix fmt`

## Updating the upstream source or NuGet deps

If `intent-system` input is updated or upstream adds/changes NuGet packages, regenerate `nuget-deps.json`:

```bash
nix build .#packages.x86_64-linux.default.fetch-deps
./result ./nuget-deps.json
```

> `nix run .#packages...default.fetch-deps` does not work because `meta.mainProgram` points to `intent-cli`; always build the script and execute it directly.

## Traps to avoid

- **Do not hardcode the package version.** `flake.nix` reads it from `${intent-system}/eng/version.json` (`nextVersion`).
- **Do not remove the `test -x` guard in `intent-system.nix` `postFixup`.** `bin/intent-cli` is a symlink to `buildDotnetModule`'s wrapper `bin/IntentSystem.Cli`; the guard ensures a missing wrapper fails the build instead of producing a broken package.
- **Do not drop `dotnetBuildFlags`.** They set `SourceRevisionId` and `IntentSystemLatestExecutionUnit` to skip upstream git-dependent MSBuild targets, which would otherwise emit git error text into `--version` output.
- **`doCheck = false` is intentional.** Upstream unit tests are not run during the package build; use `dotnet test` inside `nix develop` if you need them.

## Platform support

`supportedSystems` includes `x86_64-linux`, `aarch64-linux`, `x86_64-darwin`, and `aarch64-darwin`. Only `x86_64-linux` has been physically verified.
