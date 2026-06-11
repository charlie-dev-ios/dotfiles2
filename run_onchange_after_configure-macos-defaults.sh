#!/bin/sh
# macOS のシステム設定を `defaults` コマンドで自動適用するスクリプト。
#
# chezmoi の run_onchange_ 属性により、このスクリプトの内容が前回と
# 変わったときだけ `chezmoi apply` / `chezmoi update` の中で実行される。
# 設定を足してこのファイルを書き換えるたびに、自動で再適用される。
#
# after は「他のファイルを展開し終えた後に走らせる」ための順序指定。

set -eu

# macOS 以外（CI や Linux 端末）では何もしない。
if [ "$(uname -s)" != "Darwin" ]; then
	echo "macOS ではないため defaults の適用をスキップします。"
	exit 0
fi

echo "macOS のシステム設定を適用します..."

# --- Finder ---------------------------------------------------------------
# 拡張子を常に表示する（例: "memo" ではなく "memo.txt" と表示）。
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# --- マウス / スクロール --------------------------------------------------
# マウスの軌跡の速さ（トラッキング速度）を最大にする。
# システム設定の「マウス > 軌跡の速さ」スライダー右端が 3.0 に相当。
defaults write NSGlobalDomain com.apple.mouse.scaling -float 3.0

# マウスのスクロール速度を最大にする。
# システム設定の「マウス > スクロールの速さ」スライダー右端が 3.0 に相当。
defaults write NSGlobalDomain com.apple.scrollwheel.scaling -float 3.0

# --- 反映 -----------------------------------------------------------------
# Finder の表示変更を即座に反映するため Finder を再起動する。
killall Finder 2>/dev/null || true

echo "macOS のシステム設定を適用しました。"
echo "マウス感度・スクロール速度はログインし直すと完全に反映されます。"
