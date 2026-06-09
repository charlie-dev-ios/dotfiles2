-- Treesitter: 構文解析ベースの正確なシンタックスハイライトとインデント
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate", -- パーサを更新
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    -- よく使う言語のパーサを自動インストール
    ensure_installed = {
      "lua", "vim", "vimdoc", "bash",
      "json", "yaml", "toml", "markdown", "markdown_inline",
      "git_config", "gitignore",
    },
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
}
