-- blink.cmp: 補完エンジン (LSP 補完・スニペット・パス補完など)
-- mason は使わず、補完エンジン自体もこの 1 プラグインで完結する。
-- Rust 製で高速。version を固定するとビルド済みバイナリを取得するため
-- ローカルでの cargo ビルドは不要。
return {
  "saghen/blink.cmp",
  version = "1.*", -- ビルド済みバイナリを取得 (cargo ビルド不要)
  event = "InsertEnter",
  opts = {
    -- キーマップのプリセット:
    --   <C-space> 補完を開く / ドキュメント表示
    --   <C-y>     確定 / <C-e> キャンセル
    --   <Tab>/<S-Tab> スニペットのジャンプ
    keymap = { preset = "default" },

    appearance = {
      -- Nerd Font (Meslo) を導入済みなのでアイコンを表示する
      nerd_font_variant = "mono",
    },

    -- 補完候補のソース。LSP・バッファ・パス・スニペットを利用する。
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },

    -- ドキュメントは少し待ってから自動表示する
    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
    },
  },
}
