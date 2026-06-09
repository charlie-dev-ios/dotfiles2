-- プラグインマネージャ lazy.nvim の起動
-- 参考: https://lazy.folke.io/

-- lazy.nvim がなければ GitHub から自動でクローンする (初回起動時)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "lazy.nvim のクローンに失敗しました:\n", "ErrorMsg" },
      { out, "WarningMsg" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- lua/plugins/ 以下の各ファイルをプラグイン定義として読み込む
require("lazy").setup({
  spec = { { import = "plugins" } },
  -- TokyoNight Night で起動時のインストール画面なども揃える
  install = { colorscheme = { "tokyonight-night" } },
  -- プラグイン更新の通知は控えめにする
  checker = { enabled = false },
})
