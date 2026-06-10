# dotfiles2

M1 Mac 用の dotfiles。[chezmoi](https://www.chezmoi.io/) で管理しています。

## 構成

```
Brewfile                              # Homebrew パッケージ
.chezmoiignore                        # home へ展開しないファイル (Brewfile, README)
dot_zshenv                            → ~/.zshenv (ZDOTDIR / npm userconfig を設定)
dot_config/
├── zsh/
│   ├── dot_zprofile                  → ~/.config/zsh/.zprofile (PATH 等・ログイン時)
│   ├── dot_zshrc                     → ~/.config/zsh/.zshrc (本体・対話シェル)
│   └── create_dot_zshrc.local        → ~/.config/zsh/.zshrc.local (端末固有/管理外・雛形のみ)
├── npm/
│   └── create_npmrc                  → ~/.config/npm/npmrc (端末固有/管理外・雛形のみ)
├── ghostty/
│   ├── config                        → ~/.config/ghostty/config
│   └── themes/tokyonight_night       → ~/.config/ghostty/themes/tokyonight_night
├── eza/
│   └── theme.yml                     → ~/.config/eza/theme.yml (eza のカラーテーマ)
├── zellij/
│   └── config.kdl                    → ~/.config/zellij/config.kdl (ターミナルマルチプレクサ)
└── starship.toml                     → ~/.config/starship.toml
```

zsh の設定は `~/.zshenv` で `ZDOTDIR=~/.config/zsh` を指定し、本体を
`~/.config/zsh/` に集約しています（ホームディレクトリを汚さないため）。

`dot_` プレフィックスは chezmoi の命名規則で、`~/.` に展開されます。

### 端末固有 / 秘匿の設定 (`.zshrc.local`)

コミットしたくない端末固有の設定（会社用 PC の社内プロキシ・業務用エイリアス等）は
`~/.config/zsh/.zshrc.local` に書きます。`.zshrc` が起動時に自動で読み込みます。

このファイルはリポジトリでは `create_` 属性で「雛形だけ」管理しています。

- 端末に無ければ `chezmoi apply` で**雛形が作成**される
- 既に存在する場合は**中身を一切上書きしない**（書いた設定が消えない）
- **中身はリポジトリに同期されない**ため、社内固有の設定を入れても push されない

`*.local` は `.gitignore` 対象（雛形 `create_dot_zshrc.local` のみ例外で追跡）なので、
実ファイルの中身が誤ってコミットされることはありません。

### 端末固有 / 秘匿の npm 設定 (`npmrc`)

`~/.zshenv` で `NPM_CONFIG_USERCONFIG=~/.config/npm/npmrc` を指定し、npm の
ユーザー設定を `~/.config/npm/` に集約しています（HOME を汚さないため）。

社内レジストリや認証トークンなど、コミットしたくない設定は
`~/.config/npm/npmrc` に書きます。`.zshrc.local` と同じく `create_` 属性で
「雛形だけ」管理しており、

- 端末に無ければ `chezmoi apply` で**雛形が作成**される
- 既に存在する場合は**中身を一切上書きしない**
- **中身はリポジトリに同期されない**ため、トークン等を入れても push されない

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
