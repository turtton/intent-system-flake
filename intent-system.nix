{ lib
, buildDotnetModule
, dotnet-sdk_10
, dotnet-runtime_10
, src
, version
}:

buildDotnetModule rec {
  pname = "intent-cli";
  inherit version;

  inherit src;

  projectFile = "src/IntentSystem.Cli/IntentSystem.Cli.csproj";

  # Git-dependent MSBuild targets are bypassed via dotnetBuildFlags below,
  # so git is not required in the sandbox.

  dotnet-sdk = dotnet-sdk_10;
  dotnet-runtime = dotnet-runtime_10;

  nugetDeps = ./nuget-deps.json;

  # Build as framework-dependent executable. The apphost is produced by
  # `dotnet build`, so the output needs the dotnet runtime on PATH or via
  # the wrapped LD_LIBRARY_PATH from buildDotnetModule.
  selfContainedBuild = false;
  useAppHost = true;

  # Avoid git-dependent MSBuild targets that fail when the source is fetched
  # as a flake input (not a real git worktree). Provide deterministic metadata
  # so the `--version` output stays clean.
  dotnetBuildFlags = [
    "-p:SourceRevisionId=nixflake"
    "-p:IntentSystemLatestExecutionUnit=unknown"
  ];

  # Run only the CLI project build; tests are available via `dotnet test`
  # inside the devShell or a separate check derivation.
  doCheck = false;

  # The csproj sets <ToolCommandName>intent-cli</ToolCommandName>, but the
  # compiled apphost still uses the assembly name (IntentSystem.Cli).
  # buildDotnetModule already wraps that apphost as $out/bin/IntentSystem.Cli,
  # so expose the user-facing command name as a symlink to the wrapper.
  # Fail fast if the wrapper is missing.
  postFixup = ''
    mkdir -p "$out/bin"
    test -x "$out/bin/IntentSystem.Cli"
    ln -sfn "$out/bin/IntentSystem.Cli" "$out/bin/intent-cli"
  '';

  meta = {
    description = "Deterministic support tooling for intent-driven development on GitHub";
    homepage = "https://github.com/J-Tech-Japan/intent-system";
    license = lib.licenses.asl20;
    mainProgram = "intent-cli";
    platforms = dotnet-runtime_10.meta.platforms;
  };
}
