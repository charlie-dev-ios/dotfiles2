-- カラースキーム: TokyoNight Night
-- ghostty / eza と同じテーマに揃えて見た目を統一する。
return {
  "folke/tokyonight.nvim",
  lazy = false,    -- 起動直後に必要なので遅延読込しない
  priority = 1000, -- 他プラグインより先に読み込む
  opts = {
    style = "night",       -- night / storm / moon / day
    transparent = false,
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd.colorscheme("tokyonight-night")
  end,
}
