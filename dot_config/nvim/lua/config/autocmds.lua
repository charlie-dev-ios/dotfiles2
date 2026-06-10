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
