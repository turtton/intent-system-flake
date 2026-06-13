# intent-system Nix flake

[English README](./README.md)

[`intent-system`](https://github.com/J-Tech-Japan/intent-system) — GitHub 上での intent-driven development 向けツール `intent-cli` — を Nix でパッケージングする flake です。

## 使い方

### インストールせずに実行

```bash
nix run github:turtton/intent-system-flake -- --version
```

### ビルドして使う

```bash
nix build github:turtton/intent-system-flake
./result/bin/intent-cli --version
```

### 開発シェルに入る

```bash
nix develop github:turtton/intent-system-flake
```

シェルには `dotnet-sdk_10` と `git` が含まれます。

### チェックを実行

```bash
nix flake check github:turtton/intent-system-flake
```

パッケージのビルドと、`intent-cli --version` によるスモークテストを実行します。

## 自動更新

GitHub Actions ワークフロー（`.github/workflows/update-upstream.yml`）が、毎日上流 `intent-system` の更新を確認し、以下の条件を満たす場合にプルリクエストを作成します。

- `flake.lock` の上流リビジョンが更新されている
- `nuget-deps.json` の再生成が必要
- `nix flake check` が通過している

手動実行も Actions タブから可能です。

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
