-- Telescope: ファジーファインダ (ファイル・文字列・バッファ検索)
-- シェルで fzf を使う流儀に合わせ、エディタ内でも同様の操作感を用意する。
return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = "Telescope",
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "ファイル検索" },
    { "<leader>fg", "<cmd>Telescope live_grep<CR>",  desc = "文字列検索 (grep)" },
    { "<leader>fb", "<cmd>Telescope buffers<CR>",    desc = "バッファ一覧" },
    { "<leader>fh", "<cmd>Telescope help_tags<CR>",  desc = "ヘルプ検索" },
    { "<leader>fr", "<cmd>Telescope oldfiles<CR>",   desc = "最近開いたファイル" },
  },
  opts = {},
}
