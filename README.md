# intent-system Nix flake

[日本語版 README](./README.ja.md)

A Nix flake that packages [`intent-system`](https://github.com/J-Tech-Japan/intent-system) — the `intent-cli` tool for intent-driven development on GitHub.

## Usage

### Run without installing

```bash
nix run github:turtton/intent-system-flake -- --version
```

### Build and install

```bash
nix build github:turtton/intent-system-flake
./result/bin/intent-cli --version
```

### Enter a development shell

```bash
nix develop github:turtton/intent-system-flake
```

The shell provides `dotnet-sdk_10` and `git`.

### Run checks

```bash
nix flake check github:turtton/intent-system-flake
```

This builds the package and runs a smoke test that verifies `intent-cli --version`.

## Automated updates

A GitHub Actions workflow (`.github/workflows/update-upstream.yml`) checks for upstream `intent-system` changes daily and opens a pull request when:

- `flake.lock` has a newer upstream revision
- `nuget-deps.json` needs to be regenerated
- `nix flake check` passes

You can also trigger the workflow manually from the Actions tab.

## Files

- `flake.nix` — flake inputs and outputs (`packages`, `apps`, `devShells`, `checks`, `formatter`)
- `intent-system.nix` — `buildDotnetModule` definition for `intent-cli`
- `nuget-deps.json` — pinned NuGet dependencies (only `Tomlyn`)
- `flake.lock` — locked flake inputs

## Supported platforms

The flake declares support for:

- `x86_64-linux`
- `aarch64-linux`
- `x86_64-darwin`
- `aarch64-darwin`

Only `x86_64-linux` has been physically verified. Darwin builds should work because .NET 10 supports those platforms, but please open an issue if you hit platform-specific problems.

## License

The upstream `intent-system` project is licensed under [Apache-2.0](https://github.com/J-Tech-Japan/intent-system/blob/main/LICENSE). This flake follows the same license.
