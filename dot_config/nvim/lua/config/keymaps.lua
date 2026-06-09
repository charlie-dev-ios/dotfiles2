-- キーマッピング (リーダーキーは init.lua で Space に設定済み)

local map = vim.keymap.set

-- 検索ハイライトを Esc で消す
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "検索ハイライトを消す" })

-- ウィンドウ間の移動を Ctrl + hjkl で
map("n", "<C-h>", "<C-w>h", { desc = "左のウィンドウへ" })
map("n", "<C-j>", "<C-w>j", { desc = "下のウィンドウへ" })
map("n", "<C-k>", "<C-w>k", { desc = "上のウィンドウへ" })
map("n", "<C-l>", "<C-w>l", { desc = "右のウィンドウへ" })

-- バッファの移動
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "次のバッファ" })
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "前のバッファ" })

-- ビジュアルモードで選択行を上下に移動
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "選択行を下に移動" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "選択行を上に移動" })

-- インデント後も選択を維持する
map("v", "<", "<gv", { desc = "インデントを浅く" })
map("v", ">", ">gv", { desc = "インデントを深く" })

-- ファイルを保存
map("n", "<leader>w", "<cmd>write<CR>", { desc = "保存" })
