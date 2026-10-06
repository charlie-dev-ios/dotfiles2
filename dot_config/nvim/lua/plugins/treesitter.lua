-- Treesitter: 構文解析ベースの正確なシンタックスハイライトとインデント
--
-- nvim-treesitter の main ブランチに対応した設定。
-- 旧 master ブランチの `require("nvim-treesitter.configs").setup()` は廃止され、
-- 以下のように責務が分かれた:
--   * パーサのインストール … `require("nvim-treesitter").install(...)`
--   * ハイライトの有効化   … FileType autocmd で `vim.treesitter.start()`
--   * インデントの有効化   … `indentexpr` を treesitter のものに差し替え (実験的)
--
-- 必要要件 (main ブランチ):
--   * Neovim 0.11 以上
--   * `tree-sitter` CLI と C コンパイラ … パーサのコンパイルに使用する。
--     旧 master と違い tree-sitter CLI が無いと :TSUpdate / install() が失敗する。
--     CLI は Brewfile (brew "tree-sitter-cli") で導入する。Homebrew の "tree-sitter"
--     はライブラリのみで CLI を含まない点に注意。C コンパイラは macOS の
--     Command Line Tools (Homebrew 導入時に同梱) で入る。
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

    -- パーサを読み込めるか判定する。
    -- Neovim 0.11 以降の vim.treesitter.language.add() はパーサが無い場合に
    -- エラーを投げず `nil, エラー文言` を返すため、pcall の第1戻り値 (true) だけでは
    -- 失敗を検知できない。例外と戻り値の両方を確認する。
    local function can_load(lang)
      local ok, added, err = pcall(vim.treesitter.language.add, lang)
      return ok and added ~= nil and err == nil
    end

    -- バッファに対してハイライトとインデントを有効化する
    local function attach(buf, lang)
      vim.treesitter.start(buf, lang)
      -- treesitter ベースのインデント (実験的機能)
      vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end

    -- ハイライトの対象外にするバッファタイプ。
    -- snacks.nvim のファイラ/ピッカー/ダッシュボードなどプラグインが生成する
    -- 特殊バッファは実ファイルではなく対応するパーサも存在しないため、
    -- vim.treesitter.start() を呼ぶと「パーサが無い」エラーになる。
    -- これらは buftype が "nofile"/"prompt"/"terminal" などになるので除外する。
    -- (通常ファイルは "", ヘルプは "help" なのでこれまで通りハイライトされる)
    local skip_buftypes = {
      nofile = true,
      prompt = true,
      terminal = true,
      quickfix = true,
    }

    -- パーサが利用可能なファイルタイプでハイライトとインデントを有効化する
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local buf = args.buf
        -- 実ファイル以外の特殊バッファ (snacks など) はそもそも対象にしない
        if skip_buftypes[vim.bo[buf].buftype] then
          return
        end
        local ft = vim.bo[buf].filetype
        -- ファイルタイプに対応する treesitter の言語名を解決
        local lang = vim.treesitter.language.get_lang(ft)
        if not lang then
          return
        end
        -- パーサが入っていれば (= 追加できれば) すぐにハイライトを開始
        if can_load(lang) then
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
            if vim.api.nvim_buf_is_valid(buf) and can_load(lang) then
              attach(buf, lang)
            end
          end)
        end)
      end,
    })
  end,
}
