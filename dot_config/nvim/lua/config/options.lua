-- エディタの基本オプション

local opt = vim.opt

-- ---- 表示 ----
opt.number = true          -- 行番号を表示
opt.relativenumber = true  -- カーソル行からの相対行番号 (移動が楽になる)
opt.cursorline = true      -- カーソル行をハイライト
opt.signcolumn = "yes"     -- サイン列を常に表示して幅のガタつきを防ぐ
opt.termguicolors = true   -- 24bit カラーを有効化 (テーマの発色のため必須)
opt.wrap = false           -- 長い行を折り返さない
opt.scrolloff = 8          -- カーソル上下に最低 8 行残してスクロール
opt.signcolumn = "yes"

-- ---- インデント ----
opt.expandtab = true       -- Tab をスペースに展開
opt.shiftwidth = 2         -- 自動インデントの幅
opt.tabstop = 2            -- Tab 文字の表示幅
opt.smartindent = true     -- 構文に応じて賢くインデント

-- ---- 検索 ----
opt.ignorecase = true      -- 大文字小文字を無視して検索
opt.smartcase = true       -- ただし大文字を含むときは区別する
opt.hlsearch = true        -- 検索結果をハイライト
opt.incsearch = true       -- 入力中にインクリメンタル検索

-- ---- 編集 ----
opt.clipboard = "unnamedplus" -- システムのクリップボードを共有
opt.mouse = "a"               -- 全モードでマウスを有効化
opt.undofile = true          -- アンドゥ履歴をファイルに永続化
opt.splitright = true        -- 縦分割は右側に開く
opt.splitbelow = true        -- 横分割は下側に開く

-- ---- パフォーマンス / 操作感 ----
opt.updatetime = 250       -- スワップ書込みや CursorHold の待ち時間 (ms)
opt.timeoutlen = 400       -- マッピング入力の待ち時間 (ms)
