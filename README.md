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
│   ├── dot_zshrc                     → ~/.config/zsh/.zshrc (本体・対話シェル)
│   ├── create_dot_zshrc.work         → ~/.config/zsh/.zshrc.work (会社用・端末固有/管理外)
│   └── create_dot_zshrc.personal     → ~/.config/zsh/.zshrc.personal (私用・端末固有/管理外)
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
`~/.config/zsh/.zshrc.local` を置くと、リポジトリ管理外のローカル設定を読み込めます。

`dot_` プレフィックスは chezmoi の命名規則で、`~/.` に展開されます。

### 端末固有の設定 (会社用 / 私用)

会社用と私用で設定を分けたい場合、`.zshrc` が以下を自動で読み込みます。

| ファイル | 用途 |
| --- | --- |
| `~/.config/zsh/.zshrc.local` | 全端末共通のローカル / 秘匿設定 |
| `~/.config/zsh/.zshrc.work` | 会社用の端末でのみ書く設定 |
| `~/.config/zsh/.zshrc.personal` | 私用の端末でのみ書く設定 |

`.zshrc.work` / `.zshrc.personal` はリポジトリでは `create_` 属性で管理しています。

- 端末に無ければ `chezmoi apply` で**枠だけ**作成される
- 既に存在する場合は**中身を一切上書きしない**（書いた設定が消えない）
- **中身はリポジトリに同期されない**ため、社内固有の設定（プロキシ・社内 URL 等）を
  入れても push されない

各端末では該当するファイルにだけ中身を書きます（もう一方は空のまま読み込まれても無害）。
なお `*.local` は `.gitignore` 対象、`.zshrc.work` / `.zshrc.personal` の中身は
`create_` のため、いずれも誤ってコミットされることはありません。

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
