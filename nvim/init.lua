local g = vim.g
local merge_tb = vim.tbl_deep_extend

vim.defer_fn(function()
  pcall(require, "impatient")
end, 0)

g.mapleader = ','

vim.keymap.set('n', '/', '/\\v', { noremap = true })
vim.keymap.set('v', '/', '/\\v', { noremap = true })
-- vim.keymap.set('c', 's#', 's#\\v', { noremap = true })
vim.keymap.set('n', '<C-L>', ":nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>", { silent = true })

vim.api.nvim_create_user_command("Eols", function()
  vim.cmd(':%s#\\v\\s+$##e')
end, {})

local theme = require('onedark')
theme.setup { style = 'darker' }
theme.load()

-- LSP
local on_attach = function(client, bufnr)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

local lspconfig = require('lspconfig')
lspconfig.lua_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
}

lspconfig.nil_ls.setup {
  autostart = true,
  capabilities = capabilities,
}

lspconfig.pylsp.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    pylsp = {
      plugins = {
       pycodestyle = {
         ignore = {'W391'},
         maxLineLength = 110
       },
      },
    },
  },
}

require('colorizer').setup {
  filetypes = { "*" },
  user_default_options = {
    RGB = true, -- #RGB hex codes
    RRGGBB = true, -- #RRGGBB hex codes
    names = true, -- "Name" codes like Blue
    RRGGBBAA = true, -- #RRGGBBAA hex codes
    rgb_fn = true, -- CSS rgb() and rgba() functions
    hsl_fn = false, -- CSS hsl() and hsla() functions
    mode = "background", -- Set the display mode.
  },
}

vim.defer_fn(function()
  require("colorizer").attach_to_buffer(0)
end, 0)

require('lualine').setup()
require('nvim-autopairs').setup {
    fast_wrap = {},
    disable_filetype = { "TelescopePrompt", "vim" },
}

local M = {}

M.lspkind = {
  Namespace = "󰌗",
  Text = "󰉿 ",
  Method = "󰆧 ",
  Function = "󰆧 ",
  Constructor = " ",
  Field = "󰜢 ",
  Variable = " ",
  Class = "󰠱 ",
  Interface = " ",
  Module = " ",
  Property = "󰜢 ",
  Unit = "󰑭 ",
  Value = "󰎠 ",
  Enum = " ",
  Keyword = "󰌋 ",
  Snippet = " ",
  Color = "󰏘 ",
  File = "󰈙 ",
  Reference = "󰈇 ",
  Folder = "󰉋 ",
  EnumMember = " ",
  Constant = "󰏿 ",
  Struct = "󰙅 ",
  Event = " ",
  Operator = "󰆕 ",
  TypeParameter = "󰊄 ",
  Table = "",
  Object = "󰅩 ",
  Tag = "",
  Array = "[]",
  Boolean = " ",
  Number = " ",
  Null = "󰟢",
  String = "󰉿 ",
  Calendar = "",
  Watch = "󰥔 ",
  Package = "",
  Copilot = " ",
}

M.statusline_separators = {
  default = { left = "", right = " ", },
  round = { left = "", right = "", },
  block = { left = "█", right = "█", },
  arrow = { left = "", right = "", },
}

M.devicons = {
  default_icon = { icon = "󰈙", name = "Default", },
  c = { icon = "", name = "c", },
  css = { icon = "", name = "css", },
  deb = { icon = "", name = "deb", },
  Dockerfile = { icon = "", name = "Dockerfile", },
  html = { icon = "", name = "html", },
  jpeg = { icon = "󰉏", name = "jpeg", },
  jpg = { icon = "󰉏", name = "jpg", },
  js = { icon = "󰌞", name = "js", },
  lock = { icon = "󰌾", name = "lock", },
  lua = { icon = "", name = "lua", },
  mp3 = { icon = "󰎆", name = "mp3", },
  mp4 = { icon = "", name = "mp4", },
  out = { icon = "", name = "out", },
  png = { icon = "󰉏", name = "png", },
  py = { icon = "", name = "py", },
  toml = { icon = "", name = "toml", },
  ts = { icon = "󰛦", name = "ts", },
  ttf = { icon = "", name = "TrueTypeFont", },
  rb = { icon = "", name = "rb", },
  rpm = { icon = "", name = "rpm", },
  woff = { icon = "", name = "WebOpenFontFormat", },
  woff2 = { icon = "", name = "WebOpenFontFormat2", },
  xz = { icon = "", name = "xz", },
  zip = { icon = "", name = "zip", },
}

require('nvim-web-devicons').setup {
  override = M.devicons
}

-- TODO: moulte options
require("bufferline").setup()

-- MAPPINGS
-- n, v, i, t = mode names

local function termcodes(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local mappings = {}

mappings.general = {
  i = {
    -- go to  beginning and end
    ["<C-b>"] = { "<ESC>^i", "beginning of line" },
    ["<C-e>"] = { "<End>", "end of line" },
    ["<C-s>"] = { "<cmd> w <CR>", "save file" },
  },

  n = {
    ["n"] = { "nzzzv" },
    ["N"] = { "Nzzzv" },
    ["J"] = { "mzJ`z" },

    ["<ESC>"] = { "<cmd> noh <CR>", "no highlight" },
    ["<C-s>"] = { "<cmd> w <CR>", "save file" },

    -- Copy all
    ["<C-c>"] = { "<cmd> %y+ <CR>", "copy whole file" },

    -- line numbers
    ["<leader>n"] = { "<cmd> set nu! <CR>", "toggle line number" },
    ["<leader>rn"] = { "<cmd> set rnu! <CR>", "toggle relative number" },
    ["<leader>rr"] = { "<cmd> TermExec cmd='python3 %' <CR>", "python run" },

    -- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
    -- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
    -- empty mode is same as using <cmd> :map
    -- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
    -- new buffer
    ["<leader>b"] = { "<cmd> enew <CR>", "new buffer" },
  },

  t = { ["<C-x>"] = { termcodes "<C-\\><C-N>", "escape terminal mode" } },

  x = {
    -- Don't copy the replaced text after pasting in visual mode
    -- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
    ["p"] = { 'p:let @+=@0<CR>:let @"=@0<CR>', opts = { silent = true } },
  },

  v = {
    ["J"] = { ":m '>+1<CR>gv=gv" },
    ["K"] = { ":m '<-2<CR>gv=gv" },
  },
}

mappings.tabufline = {
  plugin = true,

  n = {
    -- cycle through buffers
    ["<TAB>"] = { "<cmd> BufferLineCycleNext <CR>", "goto next buffer"},
    ["<S-Tab>"] = { "<cmd> BufferLineCyclePrev <CR>", "goto prev buffer" },
    ["<leader>x"] = { "<cmd> bdelete <CR>", "close buffer" },
  },
}

mappings.comment = {
  plugin = true,

  -- toggle comment in both modes
  n = {
    ["<leader>/"] = {
      function()
        require("Comment.api").toggle.linewise.current()
      end,
      "toggle comment",
    },
  },

  v = {
    ["<leader>/"] = {
      "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
      "toggle comment",
    },
  },
}

mappings.lspconfig = {
  plugin = true,
  -- See `<cmd> :help vim.lsp.*` for documentation on any of the below functions
  i = {
    ["<c-k>"] = { function() vim.lsp.buf.signature_help() end, "Signature Help", has = "signatureHelp" },
  },
  n = {
    ["<leader>cd"] = { function() vim.diagnostic.open_float() end, "Line Diagnostics" },
    ["<leader>cl"] = { "<cmd>LspInfo<cr>", "Lsp Info" },
    ["gd"] = { "<cmd>Telescope lsp_definitions<cr>", "Goto Definition" },
    ["gr"] = { "<cmd>Telescope lsp_references<cr>", "References" },
    ["gD"] = { function() vim.lsp.buf.declaration() end, "Goto Declaration" },
    ["gi"] = { "<cmd>Telescope lsp_implementations<cr>", "Goto Implementation" },
    ["gt"] = { "<cmd>Telescope lsp_type_definitions<cr>", "Goto Type Definition" },
    [" "] = { function() vim.lsp.buf.hover() end, "Hover" },
    ["gK"] = { function() vim.lsp.buf.signature_help() end, "Signature Help", has = "signatureHelp" },
    ["]d"] = { function() M.diagnostic_goto(true) end, "Next Diagnostic" },
    ["[d"] = { function() M.diagnostic_goto(false) end, "Prev Diagnostic" },
    ["]e"] = { function() M.diagnostic_goto(true, "ERROR") end, "Next Error" },
    ["[e"] = { function() M.diagnostic_goto(false, "ERROR") end, "Prev Error" },
    ["]w"] = { function() M.diagnostic_goto(true, "WARN") end, "Next Warning" },
    ["[w"] = { function() M.diagnostic_goto(false, "WARN") end, "Prev Warning" },
    ["<leader>ca"] = { function() vim.lsp.buf.code_action() end, "Code Action", mode = { "n", "v" }, has = "codeAction" },
    --["<leader>cf"] = { function() format end, "Format Document", has = "documentFormatting" },
    --["<leader>cf"] = { function() format end, "Format Range", mode = "v", has = "documentRangeFormatting" },
    --["<leader>cr"] = { M.rename, "Rename", has = "rename", opts = { expr = true } },
    ["<leader>q"] = { function() vim.diagnostic.setloclist() end, "diagnostic setloclist" },
    ["<leader>wa"] = { function() vim.lsp.buf.add_workspace_folder() end, "add workspace folder" },
    ["<leader>wr"] = { function() vim.lsp.buf.remove_workspace_folder() end, "remove workspace folder" },
    ["<leader>wl"] = { function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "list workspace folders" },
  },
}

function M.rename()
  if pcall(require, "inc_rename") then
    return ":IncRename " .. vim.fn.expand("<cword>")
  else
    vim.lsp.buf.rename()
  end
end

function M.diagnostic_goto(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

mappings.nvimtree = {
  plugin = true,

  n = {
    -- toggle
    ["<C-n>"] = { "<cmd> NvimTreeToggle <CR>", "toggle nvimtree" },
    -- focus
    ["<leader>e"] = { "<cmd> NvimTreeFocus <CR>", "focus nvimtree" },
  },
}

mappings.telescope = {
  plugin = true,

  n = {
    -- find
    ["<leader>tt"] = { "<cmd> Telescope find_files <CR>", "find files" },
    ["<leader>ta"] = { "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", "find all" },
    ["<leader>td"] = { "<cmd> Telescope live_grep <CR>", "live grep" },
    ["<leader>tb"] = { "<cmd> Telescope buffers <CR>", "find buffers" },
    ["<leader>th"] = { "<cmd> Telescope help_tags <CR>", "help page" },
    ["<leader>to"] = { "<cmd> Telescope oldfiles <CR>", "find oldfiles" },
    ["<leader>tk"] = { "<cmd> Telescope keymaps <CR>", "show keys" },

    -- git
    ["<leader>cm"] = { "<cmd> Telescope git_commits <CR>", "git commits" },
    ["<leader>gt"] = { "<cmd> Telescope git_status <CR>", "git status" },

    -- pick a hidden term
    ["<leader>pt"] = { "<cmd> Telescope terms <CR>", "pick hidden term" },

    -- theme switcher
    -- ["<leader>th"] = { "<cmd> Telescope colorscheme <CR>", "colorscheme" },
    ["<leader>tz"] = { "<cmd> Telescope spell_suggest <CR>", "spelling suggestions" },
  },
}

mappings.toggleterm = {
  plugin = true,
}

mappings.blankline = {
  plugin = true,

  n = {
    ["<leader>cc"] = {
      function()
        local ok, start = require("indent_blankline.utils").get_current_context(
          vim.g.indent_blankline_context_patterns,
          vim.g.indent_blankline_use_treesitter_scope
        )

        if ok then
          vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start, 0 })
          vim.cmd [[normal! _]]
        end
      end,

      "Jump to current_context",
    },
  },
}

mappings.gitsigns = {
  plugin = true,

  n = {
    -- Navigation through hunks
    ["]c"] = {
      function()
        if vim.wo.diff then
          return "]c"
        end
        vim.schedule(function()
          require("gitsigns").next_hunk()
        end)
        return "<Ignore>"
      end,
      "Jump to next hunk",
      opts = { expr = true },
    },

    ["[c"] = {
      function()
        if vim.wo.diff then
          return "[c"
        end
        vim.schedule(function()
          require("gitsigns").prev_hunk()
        end)
        return "<Ignore>"
      end,
      "Jump to prev hunk",
      opts = { expr = true },
    },

    -- Actions
    ["<leader>rh"] = {
      function()
        require("gitsigns").reset_hunk()
      end,
      "Reset hunk",
    },

    ["<leader>ph"] = {
      function()
        require("gitsigns").preview_hunk()
      end,
      "Preview hunk",
    },

    ["<leader>gb"] = {
      function()
        package.loaded.gitsigns.blame_line()
      end,
      "Blame line",
    },

  },
}

-- END MAPPING

local load_mappings = function(g_mappings, section)
  local function set_section_map(section_values)
    if section_values.plugin then
      return
    end
    section_values.plugin = nil

    for mode, mode_values in pairs(section_values) do
      local default_opts = merge_tb("force", { mode = mode }, {})
      for keybind, mapping_info in pairs(mode_values) do
        -- merge default + user opts
        local opts = merge_tb("force", default_opts, mapping_info.opts or {})

        mapping_info.opts, opts.mode = nil, nil
        opts.desc = mapping_info[2]

        vim.keymap.set(mode, keybind, mapping_info[1], opts)
      end
    end
  end

  local mappings = g_mappings

  if type(section) == "string" then
    mappings[section]["plugin"] = nil
    mappings = { mappings[section] }
  end

  for _, sect in pairs(mappings) do
    set_section_map(sect)
  end
end

load_mappings(mappings)
load_mappings(mappings, "general")
load_mappings(mappings, "tabufline")
load_mappings(mappings, "comment")
load_mappings(mappings, "lspconfig")
load_mappings(mappings, "nvimtree")
load_mappings(mappings, "telescope")
load_mappings(mappings, "toggleterm")
load_mappings(mappings, "blankline")
load_mappings(mappings, "gitsigns")

-- OPTIONS
g.toggle_theme_icon = "   "

local opt = vim.opt

opt.autowrite = true -- Enable auto write
opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 3 -- Hide * markup for bold and italic
opt.confirm = false -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true -- Ignore case
opt.inccommand = "nosplit" -- preview incremental substitute
opt.laststatus = 3 -- global statusline
opt.list = true -- Show some invisible characters (tabs...
opt.mouse = "a" -- Enable mouse mode
opt.number = true -- Print line number
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.relativenumber = true -- Relative line numbers
opt.scrolloff = 4 -- Lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.shortmess:append { W = true, I = true, c = true }
opt.showmode = false -- Dont show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.spelllang = { "en" }
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
opt.tabstop = 2 -- Number of spaces tabs count for
opt.termguicolors = true -- True color support
opt.timeoutlen = 300
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.wrap = false -- Disable line wrap.transparency = fa/malse
g.markdown_recommended_style = 0
opt.fillchars = { eob = " " }
opt.numberwidth = 4

--opt.shortmess:append "sI"
opt.whichwrap:append "<>[]hl"

-- disable some builtin vim plugins
local default_plugins = {
  "2html_plugin",
  "getscript",
  "getscriptPlugin",
  "gzip",
  "logipat",
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "matchit",
  "tar",
  "tarPlugin",
  "rrhelper",
  "spellfile_plugin",
  "vimball",
  "vimballPlugin",
  "zip",
  "zipPlugin",
  "tutor",
  "rplugin",
  "syntax",
  "synmenu",
  "optwin",
  "compiler",
  "bugreport",
  "ftplugin",
}

for _, plugin in pairs(default_plugins) do
  g["loaded_" .. plugin] = 1
end

local default_providers = {
  "python3",
}

for _, provider in ipairs(default_providers) do
  vim.g["loaded_" .. provider .. "_provider"] = 0
end


-- TELESCOPE
local telescope = require("telescope")
telescope.setup {
  options = {
    defaults = {
      vimgrep_arguments = {
        "rg",
        "-L",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
      },
      prompt_prefix = "   ",
      selection_caret = "  ",
      entry_prefix = "  ",
      initial_mode = "insert",
      selection_strategy = "reset",
      sorting_strategy = "ascending",
      layout_strategy = "horizontal",
      layout_config = {
        horizontal = {
          prompt_position = "top",
          preview_width = 0.55,
          results_width = 0.8,
        },
        vertical = {
          mirror = false,
        },
        width = 0.87,
        height = 0.80,
        preview_cutoff = 120,
      },
      file_sorter = require("telescope.sorters").get_fuzzy_file,
      file_ignore_patterns = { "node_modules" },
      generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
      path_display = { "truncate" },
      winblend = 0,
      border = {},
      borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      color_devicons = true,
      set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
      file_previewer = require("telescope.previewers").vim_buffer_cat.new,
      grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
      qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
      -- Developer configurations: Not meant for general override
      buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
      mappings = {
        n = { ["q"] = require("telescope.actions").close },
      },
    },

    extensions = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  }
}

telescope.load_extension("fzf")

-- TOGGLETERM
local toggleterm = require("toggleterm").setup {

}

-- NVIM-TREE
local nvimtree = require("nvim-tree")

local options = {
  filters = {
    dotfiles = false,
    exclude = { vim.fn.stdpath "config" .. "/lua/custom" },
  },
  disable_netrw = true,
  hijack_netrw = true,
  hijack_cursor = true,
  hijack_unnamed_buffer_when_opening = false,
  update_cwd = true,
  update_focused_file = {
    enable = true,
    update_cwd = false,
  },
  view = {
    adaptive_size = true,
    side = "left",
    width = 25,
  },
  git = {
    enable = false,
    ignore = true,
  },
  filesystem_watchers = {
    enable = true,
  },
  actions = {
    open_file = {
      resize_window = true,
    },
  },
  renderer = {
    highlight_git = false,
    highlight_opened_files = "none",
    root_folder_label = false,

    indent_markers = {
      enable = false,
    },

    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = false,
      },

      glyphs = {
        default = "",
        symlink = "",
        folder = {
          default = "",
          empty = "",
          empty_open = "",
          open = "",
          symlink = "",
          symlink_open = "",
          arrow_open = "",
          arrow_closed = "",
        },
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
      },
    },
  },
}

vim.g.nvimtree_side = options.view.side
nvimtree.setup(options)

-- TREESITTER

local treesitter = require("nvim-treesitter")
local options = {
  highlight = {
    enable = true,
    use_languagetree = true,
  },
  indent = { enable = true },
}

treesitter.setup(options)


-- CMP
local luasnip = require("luasnip")
luasnip.config.set_config {
  history = true,
  updateevents = "TextChanged,TextChangedI"
}
require("luasnip.loaders.from_vscode").lazy_load { paths = vim.g.luasnippets_path or "" }
require("luasnip.loaders.from_vscode").lazy_load()

vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    if
      require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
      and not require("luasnip").session.jump_active
    then
      require("luasnip").unlink_current()
    end
  end,
})

local cmp = require("cmp")

--require("base46").load_highlight "cmp"

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

local function border(hl_name)
  return {
    { "╭", hl_name },
    { "─", hl_name },
    { "╮", hl_name },
    { "│", hl_name },
    { "╯", hl_name },
    { "─", hl_name },
    { "╰", hl_name },
    { "│", hl_name },
  }
end

local cmp_window = require "cmp.utils.window"

cmp_window.info_ = cmp_window.info
cmp_window.info = function(self)
  local info = self:info_()
  info.scrollable = false
  return info
end

local options = {
  window = {
    completion = {
      border = border "CmpBorder",
      winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
    },
    documentation = {
      border = border "CmpDocBorder",
    },
  },

  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  formatting = {
    format = function(_, vim_item)
      local icons = M.lspkind
      vim_item.kind = string.format("%s %s", icons[vim_item.kind], vim_item.kind)
      return vim_item
    end,
  },
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif require("luasnip").expand_or_jumpable() then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif require("luasnip").jumpable(-1) then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "nvim_lua" },
    { name = "path" },
    { name = "greek" },
    { name = "nvim_lsp_signature_help" },
  },
}

cmp.setup(options)

local wk = require('which-key')

wk.setup {
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = " 󰁔 ", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
  },

  layout = {
    spacing = 4, -- spacing between columns
  },
}

require("trouble").setup {}
require("fidget").setup {}
