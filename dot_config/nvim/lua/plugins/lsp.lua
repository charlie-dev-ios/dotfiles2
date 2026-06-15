-- LSP: 言語サーバ連携 (補完候補の提供・定義ジャンプ・診断・リネーム等)
--
-- 方針:
--   * LSP サーバ本体は mason ではなく mise で管理する
--     (~/.config/mise/config.toml)。lspconfig は PATH 上のサーバを
--     探すだけなので、mise で入れて PATH を通せばそのまま動く。
--   * 補完候補は blink.cmp に渡す (capabilities を blink から取得)。
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "saghen/blink.cmp" },
  config = function()
    -- ---- 診断 (エラー / 警告) の表示設定 ----
    vim.diagnostic.config({
      virtual_text = true,    -- 行末にメッセージを表示
      underline = true,       -- 該当箇所に下線
      update_in_insert = false,
      severity_sort = true,   -- 重大度順に並べる
    })

    -- ---- LSP がバッファにアタッチしたときのキーマップ ----
    -- LSP が動いているバッファでだけ有効にしたいので LspAttach で設定する。
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
      callback = function(ev)
        local map = function(keys, fn, desc)
          vim.keymap.set("n", keys, fn, { buffer = ev.buf, desc = "LSP: " .. desc })
        end

        map("gd", vim.lsp.buf.definition, "定義へジャンプ")
        map("gD", vim.lsp.buf.declaration, "宣言へジャンプ")
        map("gr", vim.lsp.buf.references, "参照一覧")
        map("gi", vim.lsp.buf.implementation, "実装へジャンプ")
        map("K", vim.lsp.buf.hover, "ホバー (型・ドキュメント)")
        map("<Leader>rn", vim.lsp.buf.rename, "シンボルをリネーム")
        map("<Leader>ca", vim.lsp.buf.code_action, "コードアクション")
        map("<Leader>cf", function() vim.lsp.buf.format({ async = true }) end, "フォーマット")
        map("[d", function() vim.diagnostic.jump({ count = -1 }) end, "前の診断へ")
        map("]d", function() vim.diagnostic.jump({ count = 1 }) end, "次の診断へ")
        map("<Leader>cd", vim.diagnostic.open_float, "診断をフロート表示")
      end,
    })

    -- 補完能力 (capabilities) を blink.cmp から取得して各サーバへ渡す。
    -- これにより LSP の補完候補が blink.cmp に流れる。
    local capabilities = require("blink.cmp").get_lsp_capabilities()
    local lspconfig = require("lspconfig")

    -- ---- lua_ls (Lua の LSP。この nvim 設定自体を書くのに有用) ----
    -- サーバ本体は mise の aqua:LuaLS/lua-language-server で導入する。
    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      settings = {
        Lua = {
          -- `vim` をグローバルとして認識させ "undefined global" を消す
          diagnostics = { globals = { "vim" } },
          -- Neovim のランタイムを補完対象に含める
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          -- テレメトリは送らない
          telemetry = { enable = false },
        },
      },
    })
  end,
}
