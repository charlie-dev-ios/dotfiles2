# dotfiles2

M1 Mac 用の dotfiles。[chezmoi](https://www.chezmoi.io/) で管理しています。

## 構成

```
Brewfile                              # Homebrew パッケージ
.chezmoiignore                        # home へ展開しないファイル (Brewfile, README)
dot_zshenv                            → ~/.zshenv (ZDOTDIR を設定するだけ)
dot_config/
├── zsh/
│   ├── dot_zprofile                  → ~/.config/zsh/.zprofile (PATH 等・ログイン時)
│   └── dot_zshrc                     → ~/.config/zsh/.zshrc (本体・対話シェル)
├── ghostty/
│   ├── config                        → ~/.config/ghostty/config
│   └── themes/tokyonight_night       → ~/.config/ghostty/themes/tokyonight_night
├── eza/
│   └── theme.yml                     → ~/.config/eza/theme.yml (eza のカラーテーマ)
├── mise/
│   └── config.toml                   → ~/.config/mise/config.toml (mise で管理するツール)
├── nvim/                             → ~/.config/nvim/ (Neovim の設定)
│   ├── init.lua                      # エントリポイント
│   └── lua/
│       ├── config/                   # options / keymaps / lazy (起動設定)
│       └── plugins/                  # プラグインごとの設定 (lazy.nvim が自動読込)
└── starship.toml                     → ~/.config/starship.toml
```

zsh の設定は `~/.zshenv` で `ZDOTDIR=~/.config/zsh` を指定し、本体を
`~/.config/zsh/` に集約しています（ホームディレクトリを汚さないため）。
`~/.config/zsh/.zshrc.local` を置くと、リポジトリ管理外のローカル設定を読み込めます。

`dot_` プレフィックスは chezmoi の命名規則で、`~/.` に展開されます。

## セットアップ

### 1. 前提ツール

[Homebrew](https://brew.sh/) を公式サイトの手順に従ってインストールしてください（Command Line Tools も同時に導入されます）。

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

### 4. mise でツールを導入

Neovim などは Homebrew ではなく [mise](https://mise.jdx.dev/) で管理しています。
`~/.config/mise/config.toml` に書かれたツールを一括インストールします。

```sh
mise install
```

Neovim 初回起動時に [lazy.nvim](https://lazy.folke.io/) が自動でインストールされ、
プラグインも自動で取得されます。アイコンの表示には Nerd Font が必要です
（ghostty のフォント設定に合わせてください）。

```sh
nvim
```
