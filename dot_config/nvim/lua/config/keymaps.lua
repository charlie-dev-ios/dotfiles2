-- キーマッピング (リーダーキーは init.lua で Space に設定済み)

local map = vim.keymap.set

-- ---- 挿入モード ----
-- jj で素早く挿入モードを抜ける
map("i", "jj", "<Esc>", { desc = "挿入モードを抜ける" })

-- ---- 検索 ----
-- 検索ハイライトを消す (元 dotfiles に合わせて Leader+Esc)
map("n", "<Leader><Esc>", "<cmd>nohlsearch<CR>", { desc = "検索ハイライトを消す" })

-- ---- カーソル移動 ----
-- 折り返した行も 1 行として上下移動する
map("n", "j", "gj", { desc = "表示行で下に移動" })
map("n", "k", "gk", { desc = "表示行で上に移動" })

-- ---- ウィンドウ ----
-- Ctrl + hjkl でウィンドウ間を直接移動
map("n", "<C-h>", "<C-w>h", { desc = "左のウィンドウへ" })
map("n", "<C-j>", "<C-w>j", { desc = "下のウィンドウへ" })
map("n", "<C-k>", "<C-w>k", { desc = "上のウィンドウへ" })
map("n", "<C-l>", "<C-w>l", { desc = "右のウィンドウへ" })

-- Leader+s をウィンドウ操作 (<C-w>) のプレフィックスにする
-- 例: <Leader>sv 縦分割 / <Leader>ss 横分割 / <Leader>sh/j/k/l 移動
map("n", "<Leader>s", "<C-w>", { desc = "ウィンドウ操作 (C-w)" })
-- ウィンドウサイズを 4 単位で調整
map("n", "<Leader>s<", "4<C-w><", { desc = "幅を狭く" })
map("n", "<Leader>s>", "4<C-w>>", { desc = "幅を広く" })
map("n", "<Leader>s+", "4<C-w>+", { desc = "高さを高く" })
map("n", "<Leader>s-", "4<C-w>-", { desc = "高さを低く" })

-- ---- バッファ ----
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "次のバッファ" })
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "前のバッファ" })

-- ---- ビジュアルモード ----
-- 選択行を上下に移動
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "選択行を下に移動" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "選択行を上に移動" })
-- インデント後も選択を維持する
map("v", "<", "<gv", { desc = "インデントを浅く" })
map("v", ">", ">gv", { desc = "インデントを深く" })

-- ---- ファイル / 設定 ----
-- ファイルを保存
map("n", "<leader>w", "<cmd>write<CR>", { desc = "保存" })
-- init.lua を再読込する
map("n", "<Leader>0", function()
  vim.cmd.source(vim.fn.stdpath("config") .. "/init.lua")
end, { desc = "設定を再読込" })
