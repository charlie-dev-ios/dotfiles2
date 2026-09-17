-- 自動コマンド (autocmd)

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- ヤンクした範囲を一瞬ハイライトして、何をコピーしたか分かりやすくする
autocmd("TextYankPost", {
  group = augroup("highlight_yank", { clear = true }),
  callback = function()
    -- 新しい Neovim では vim.hl、古い版では vim.highlight に置かれている
    local hl = vim.hl or vim.highlight
    hl.on_yank({ timeout = 200 })
  end,
})

-- ファイルを開いたとき、前回閉じたときのカーソル位置に復元する
autocmd("BufReadPost", {
  group = augroup("restore_cursor", { clear = true }),
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    -- マークが有効な行範囲内のときだけジャンプする
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- ファイルタイプごとのインデント幅 (dotfiles の設定に合わせる)
-- 既定は 4 スペースで、言語ごとの慣習に合わせて上書きする
local indent_by_filetype = {
  lua = 2,
  swift = 4,
}

autocmd("FileType", {
  group = augroup("filetype_indent", { clear = true }),
  pattern = vim.tbl_keys(indent_by_filetype),
  callback = function(args)
    local width = indent_by_filetype[vim.bo[args.buf].filetype]
    if width then
      vim.opt_local.tabstop = width
      vim.opt_local.softtabstop = width
      vim.opt_local.shiftwidth = width
    end
  end,
})
