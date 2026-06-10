-- snacks.nvim: ファイラ (Explorer) として使う
-- folke 製 (lazy.nvim / tokyonight と同じ作者) なので構成との親和性が高い。
-- Explorer は内部的に picker を使うため、両モジュールを有効化する。
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false, -- nvim <dir> で起動したときにファイラを開くため常駐させる
  keys = {
    -- 元 dotfiles の nvim-tree と同じ <Leader>e 系プレフィックスに合わせる
    { "<Leader>ee", function() Snacks.explorer() end, desc = "ファイラを開閉" },
  },
  opts = {
    explorer = {
      replace_netrw = true, -- netrw の代わりにディレクトリを開く
    },
    picker = {
      sources = {
        explorer = {
          hidden = true, -- 隠しファイルも表示する
        },
      },
    },
  },
}
