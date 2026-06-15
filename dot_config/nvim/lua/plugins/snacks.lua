-- snacks.nvim: ファイラ (Explorer) とファジーファインダ (Picker)
-- folke 製 (lazy.nvim / tokyonight と同じ作者) なので構成との親和性が高い。
-- Explorer は内部的に picker を使うため、検索もこの picker に一本化している
-- (旧 telescope は廃止)。
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false, -- nvim <dir> で起動したときにファイラを開くため常駐させる
  keys = {
    -- ファイラ (元 dotfiles の nvim-tree と同じ <Leader>e 系プレフィックス)
    { "<Leader>ee", function() Snacks.explorer() end, desc = "ファイラを開閉" },
    { "<Leader>ef", function() Snacks.explorer.reveal() end, desc = "ファイラで現在のファイルをreveal" },

    -- ファジーファインダ (旧 telescope の <Leader>f 系を踏襲)
    { "<Leader>ff", function() Snacks.picker.files() end,   desc = "ファイル検索" },
    { "<Leader>fg", function() Snacks.picker.grep() end,    desc = "文字列検索 (grep)" },
    { "<Leader>fb", function() Snacks.picker.buffers() end, desc = "バッファ一覧" },
    { "<Leader>fh", function() Snacks.picker.help() end,    desc = "ヘルプ検索" },
    { "<Leader>fr", function() Snacks.picker.recent() end,  desc = "最近開いたファイル" },
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
