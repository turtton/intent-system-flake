# intent-system Nix flake

[`intent-system`](https://github.com/J-Tech-Japan/intent-system) — GitHub 上での intent-driven development 向けツール `intent-cli` — を Nix でパッケージングする flake です。

## 使い方

### インストールせずに実行

```bash
nix run /path/to/intent-system-flake -- --version
```

### ビルドして使う

```bash
nix build /path/to/intent-system-flake
./result/bin/intent-cli --version
```

### 開発シェルに入る

```bash
nix develop /path/to/intent-system-flake
```

シェルには `dotnet-sdk_10` と `git` が含まれます。

### チェックを実行

```bash
nix flake check /path/to/intent-system-flake
```

パッケージのビルドと、`intent-cli --version` によるスモークテストを実行します。

## ファイル構成

- `flake.nix` — flake の inputs / outputs（`packages`, `apps`, `devShells`, `checks`, `formatter`）
- `intent-system.nix` — `intent-cli` の `buildDotnetModule` 定義
- `nuget-deps.json` — 固定された NuGet 依存（`Tomlyn` のみ）
- `flake.lock` — ロックされた flake inputs

## サポートするプラットフォーム

以下のプラットフォームを宣言しています。

- `x86_64-linux`
- `aarch64-linux`
- `x86_64-darwin`
- `aarch64-darwin`

実機で動作確認済みなのは `x86_64-linux` のみです。Darwin 系は .NET 10 がサポートしているためビルドは通るはずですが、プラットフォーム固有の問題があれば issue を開いてください。

## ライセンス

上流の `intent-system` プロジェクトと同じく [Apache-2.0](https://github.com/J-Tech-Japan/intent-system/blob/main/LICENSE) ライセンスです。
