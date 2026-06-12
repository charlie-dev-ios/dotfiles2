# dotfiles2

M1 Mac 用の dotfiles。[chezmoi](https://www.chezmoi.io/) で管理しています。

## 構成

```
Brewfile                              # Homebrew パッケージ
.chezmoiignore                        # home へ展開しないファイル (Brewfile, README)
run_onchange_after_install-packages.sh.tmpl  # Brewfile 変更時に brew bundle で差分インストール
run_onchange_after_configure-macos-defaults.sh  # macOS のシステム設定を defaults で自動適用
dot_zshenv                            → ~/.zshenv (ZDOTDIR / npm userconfig を設定)
dot_config/
├── zsh/
│   ├── dot_zprofile                  → ~/.config/zsh/.zprofile (PATH 等・ログイン時)
│   ├── dot_zshrc                     → ~/.config/zsh/.zshrc (本体・対話シェル)
│   └── create_dot_zshrc.local        → ~/.config/zsh/.zshrc.local (端末固有/管理外・雛形のみ)
├── git/
│   ├── config                        → ~/.config/git/config (全端末共通の Git 設定)
│   ├── ignore                        → ~/.config/git/ignore (グローバル無視・.DS_Store 等)
│   └── create_config.local           → ~/.config/git/config.local (端末固有/管理外・雛形のみ)
├── npm/
│   └── create_npmrc                  → ~/.config/npm/npmrc (端末固有/管理外・雛形のみ)
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
│       ├── config/                   # options / keymaps / autocmds / lazy (起動設定)
│       └── plugins/                  # プラグインごとの設定 (lazy.nvim が自動読込)
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

### Git の共通設定と端末固有設定 (`git/config` / `config.local`)

Git は XDG 既定で `~/.config/git/config` を読み込むため、`~/.gitconfig` を
使わずここに集約しています（HOME を汚さないため）。

- `~/.config/git/config` … **どの端末でも絶対に共通**の設定（コミット対象）。
  - `.DS_Store` 等の無視は `~/.config/git/ignore`（グローバル無視ファイル）で行う
  - ファイル名/ディレクトリ名の大文字小文字を厳密に区別（`core.ignorecase = false`）
- `~/.config/git/config.local` … 会社用 Mac の社内プロキシなど、**端末固有 / 秘匿**の設定。

`config` は末尾で `config.local` を `include` しています。include は後勝ちのため、
`config.local` 側で共通設定を**安全に上書き**できます。

`config.local` は `.zshrc.local` と同じく `create_` 属性で「雛形だけ」管理しており、

- 端末に無ければ `chezmoi apply` で**雛形が作成**される
- 既に存在する場合は**中身を一切上書きしない**（プロキシ設定が消えない）
- **中身はリポジトリに同期されない**ため、プロキシやトークンを入れても push されない

会社用 Mac では `~/.config/git/config.local` に次のように書きます。

```ini
[http]
	proxy = http://proxy.example.com:8080
[https]
	proxy = http://proxy.example.com:8080
```

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

chezmoi 自体も Brewfile に含めているため、ブートストラップ後はこの手順で
Homebrew 管理下に置かれます（更新方法は後述の「更新」を参照）。

### 4. mise でツールを導入

Neovim などは Homebrew ではなく [mise](https://mise.jdx.dev/) で管理しています。
`~/.config/mise/config.toml` に書かれたツールを一括インストールします。

```sh
mise install
```

Neovim 初回起動時に [lazy.nvim](https://lazy.folke.io/) が自動でインストールされ、
プラグインも自動で取得されます。アイコン表示用の Nerd Font (Meslo) は
手順 3 の `brew bundle` で導入されます。

```sh
nvim
```

## 更新

### dotfiles の更新

リポジトリの最新を取り込んでホームに反映します。

```sh
chezmoi update
```

`chezmoi update` は `git pull` で最新を取得し、そのまま `chezmoi apply` まで
実行します。差分だけ確認したい場合は次のようにします。

```sh
chezmoi git pull          # ソースだけ更新
chezmoi diff              # 反映前に差分を確認
chezmoi apply             # 問題なければ反映
```

### Homebrew パッケージの差分インストール（自動）

`chezmoi update` / `chezmoi apply` の中で、**Brewfile が変わったときだけ**
Homebrew パッケージの差分が自動でインストールされます。
Brewfile に行を足して `chezmoi update` するだけで、増えたパッケージが入ります。

これは `run_onchange_after_install-packages.sh.tmpl` という chezmoi のスクリプトで
実現しています。

- `run_onchange_` … スクリプト末尾に埋め込んだ Brewfile のハッシュが変わった
  ときだけ実行される（毎回は走らないので `chezmoi apply` が重くならない）
- 中身は `brew bundle` … Brewfile のうち**未導入のものだけ**を入れる（差分インストール）。
  既に入っているパッケージは再インストールされない
- `brew` が無い端末（CI 等）では何もせずスキップする

### Homebrew パッケージの手動更新

新しいパッケージの導入は上記のとおり `chezmoi update` で自動化されていますが、
Homebrew 本体や導入済みパッケージの**バージョン更新**は手動で行います。

```sh
brew update                                            # Homebrew 本体の更新
brew bundle --file=~/.local/share/chezmoi/Brewfile     # Brewfile の追加分を導入（差分）
brew upgrade                                            # 導入済みパッケージを更新
```

### mise で管理するツールの更新

```sh
mise upgrade              # config.toml の範囲で更新
mise install              # 追加したツールを導入
```

## macOS のシステム設定（自動）

`chezmoi apply` / `chezmoi update` の中で、macOS のシステム設定を
`defaults` コマンドで自動適用します。`run_onchange_after_configure-macos-defaults.sh`
が担当しており、

- `run_onchange_` … スクリプトの内容が変わったときだけ実行される（毎回は走らない）
- macOS 以外の端末（CI / Linux）では `uname` を見て何もせずスキップする

現在、次の設定を適用しています。

- **Finder で拡張子を常に表示**（`AppleShowAllExtensions`）
- **マウスの軌跡の速さ（トラッキング速度）を最大**（`com.apple.mouse.scaling = 3.0`、
  システム設定のスライダー右端に相当）
- **マウスのスクロール速度を最大**（`com.apple.scrollwheel.scaling = 3.0`、同上）
- **ホットコーナーを 4 隅すべて無効化**（`com.apple.dock wvous-*-corner = 1`、
  画面の隅での Mission Control 等の誤発動を防止）

設定を増やしたいときはこのスクリプトに `defaults write ...` を追記して
`chezmoi update` するだけで反映されます。マウス感度・スクロール速度は
ログインし直すと完全に反映されます。
