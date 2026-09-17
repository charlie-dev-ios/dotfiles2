-- エディタの基本オプション
-- dotfiles (vim/lua/options.lua) で設定している項目は、そちらの値に合わせている

local opt = vim.opt

-- ---- 表示 ----
opt.number = true          -- 行番号を表示
opt.relativenumber = true  -- カーソル行からの相対行番号 (移動が楽になる)
opt.cursorline = true      -- カーソル行をハイライト
opt.cursorcolumn = false   -- カーソル列はハイライトしない
opt.signcolumn = "yes"     -- サイン列を常に表示して幅のガタつきを防ぐ
opt.termguicolors = true   -- 24bit カラーを有効化 (テーマの発色のため必須)
opt.showmode = true        -- 現在のモードを画面下に表示
opt.wrap = true            -- 長い行を画面端で折り返す
opt.linebreak = false      -- 折り返し位置を単語境界に寄せず、画面端で折り返す
opt.scrolloff = 8          -- カーソル上下に最低 8 行残してスクロール

-- ---- インデント ----
opt.expandtab = true       -- Tab をスペースに展開
opt.tabstop = 4            -- Tab 文字の表示幅
opt.softtabstop = 4        -- 挿入・削除時に Tab が動かす幅
opt.shiftwidth = 4         -- 自動インデントの幅
opt.smartindent = true     -- 構文に応じて賢くインデント
opt.autoindent = true      -- 改行時に前の行のインデントを引き継ぐ

-- ---- 検索 ----
opt.ignorecase = true      -- 大文字小文字を無視して検索
opt.smartcase = true       -- ただし大文字を含むときは区別する
opt.hlsearch = true        -- 検索結果をハイライト
opt.incsearch = true       -- 入力中にインクリメンタル検索

-- ---- 編集 ----
opt.clipboard:append({ "unnamedplus" }) -- システムのクリップボードを共有
opt.mouse = "a"               -- 全モードでマウスを有効化
opt.autoread = true           -- 外部で更新されたファイルを自動で読み直す
opt.undofile = true           -- アンドゥ履歴をファイルに永続化
opt.splitright = true         -- 縦分割は右側に開く
opt.splitbelow = true         -- 横分割は下側に開く

-- ---- スペルチェック ----
opt.spell = false          -- 既定では無効
opt.spelllang = { "en_us" }

-- ---- パフォーマンス / 操作感 ----
opt.updatetime = 250       -- スワップ書込みや CursorHold の待ち時間 (ms)
opt.timeoutlen = 700       -- マッピング入力の待ち時間 (ms)
