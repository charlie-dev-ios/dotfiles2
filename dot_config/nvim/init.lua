-- Neovim 設定のエントリポイント (~/.config/nvim/init.lua)
--
-- 役割ごとにモジュールを分割している:
--   lua/config/options.lua  … エディタの基本オプション
--   lua/config/keymaps.lua  … キーマッピング
--   lua/config/lazy.lua     … プラグインマネージャ (lazy.nvim) の起動
--   lua/plugins/            … プラグインごとの設定 (lazy.nvim が自動読込)

-- リーダーキーはプラグイン読込より前に設定しておく必要がある
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.keymaps")
require("config.lazy")
