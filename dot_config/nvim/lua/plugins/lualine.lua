-- Lualine: ステータスライン
-- テーマを tokyonight に合わせて全体の配色を統一する。
return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = {
    options = {
      theme = "tokyonight",
      icons_enabled = true,
      globalstatus = true, -- ウィンドウ分割時も 1 本のステータスラインにする
    },
  },
}
