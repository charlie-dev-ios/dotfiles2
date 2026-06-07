# dotfiles2

M1 Mac 用の dotfiles。[chezmoi](https://www.chezmoi.io/) で管理しています。

## 構成

```
Brewfile                              # Homebrew パッケージ (git, mise)
.chezmoiignore                        # home へ展開しないファイル (Brewfile, README)
dot_config/
├── ghostty/
│   ├── config                        → ~/.config/ghostty/config
│   └── themes/tokyonight_night       → ~/.config/ghostty/themes/tokyonight_night
└── starship.toml                     → ~/.config/starship.toml
```

`dot_` プレフィックスは chezmoi の命名規則で、`~/.` に展開されます。

## セットアップ

### 1. 前提ツール

```sh
# Homebrew (Command Line Tools も同時に導入される)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. chezmoi で適用

chezmoi はバイナリを取得して動くため、git が未導入でもブートストラップできます。

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply charlie-dev-ios/dotfiles2
```

これで `dot_config/` 以下がホームディレクトリに展開されます。

### 3. Homebrew パッケージ

```sh
brew bundle --file=~/.local/share/chezmoi/Brewfile
```

## 含まれる設定

- **ghostty** — ターミナル。MesloLG Nerd Font + Tokyo Night テーマ
- **starship** — プロンプト。Tokyo Night 配色
- **mise** — ランタイムバージョン管理
