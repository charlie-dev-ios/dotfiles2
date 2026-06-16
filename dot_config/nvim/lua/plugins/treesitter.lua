-- Treesitter: 構文解析ベースの正確なシンタックスハイライトとインデント
--
-- nvim-treesitter の main ブランチに対応した設定。
-- 旧 master ブランチの `require("nvim-treesitter.configs").setup()` は廃止され、
-- 以下のように責務が分かれた:
--   * パーサのインストール … `require("nvim-treesitter").install(...)`
--   * ハイライトの有効化   … FileType autocmd で `vim.treesitter.start()`
--   * インデントの有効化   … `indentexpr` を treesitter のものに差し替え (実験的)
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main", -- 新 API を使うため main ブランチを明示
  build = ":TSUpdate", -- パーサを更新
  lazy = false, -- main ブランチは遅延読込と相性が悪いため即時読込する
  config = function()
    -- よく使う言語のパーサを自動インストール (非同期で実行される)
    local ensure_installed = {
      "lua", "vim", "vimdoc", "bash",
      "json", "yaml", "toml", "markdown", "markdown_inline",
      "git_config", "gitignore",
    }
    require("nvim-treesitter").install(ensure_installed)

    -- バッファに対してハイライトとインデントを有効化する
    local function attach(buf, lang)
      vim.treesitter.start(buf, lang)
      -- treesitter ベースのインデント (実験的機能)
      vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end

    -- パーサが利用可能なファイルタイプでハイライトとインデントを有効化する
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local buf = args.buf
        local ft = vim.bo[buf].filetype
        -- ファイルタイプに対応する treesitter の言語名を解決
        local lang = vim.treesitter.language.get_lang(ft)
        if not lang then
          return
        end
        -- パーサが入っていれば (= 追加できれば) すぐにハイライトを開始
        if pcall(vim.treesitter.language.add, lang) then
          attach(buf, lang)
          return
        end
        -- 未インストールなら自動でインストールし、完了後に有効化する
        -- (旧 master ブランチの auto_install = true 相当の挙動)
        -- インストール可能なパーサだけを対象にする
        if not vim.tbl_contains(require("nvim-treesitter.config").get_available(), lang) then
          return
        end
        require("nvim-treesitter").install({ lang }):await(function(err)
          if err then
            return
          end
          -- インストール完了は別スレッド/コルーチンのため UI 操作は schedule する。
          -- 完了までにバッファが閉じている可能性があるので有効性も確認する。
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(buf) and pcall(vim.treesitter.language.add, lang) then
              attach(buf, lang)
            end
          end)
        end)
      end,
    })
  end,
}
