-- Minimal Neovim config — small, fast, distributable
-- Lazy.nvim bootstraps itself, everything else is declarative

-- Leader key must be set BEFORE lazy.nvim loads
vim.g.mapleader = " "

-- Disable netrw's file explorer — oil.nvim handles directories
vim.g.loaded_netrwPlugin = 1

-- Bootstrap lazy.nvim -------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Options -------------------------------------------------------------------
vim.opt.number = true
vim.opt.mouse = "a"
vim.opt.termguicolors = true
vim.opt.hidden = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.clipboard = "unnamedplus" -- system clipboard for yy/d/x
vim.opt.autoread = true -- required for opencode.nvim
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.showmode = false -- lualine ya muestra el modo

-- Keymaps -------------------------------------------------------------------
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Smart q: no macro recording, keeps q:/q//q?
map("n", "q", function()
  local c = vim.fn.getcharstr()
  if c == ":" or c == "/" or c == "?" then
    vim.api.nvim_feedkeys("q" .. c, "n", false)
  end
end, { desc = "Smart q: no recordings, keeps q:/q?/q:" })

-- Window navigation with hjkl
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Resize windows
map("n", "<C-Up>", "<cmd>resize +2<CR>", opts)
map("n", "<C-Down>", "<cmd>resize -2<CR>", opts)
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", opts)
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", opts)

-- Window management via <leader>w (which-key shows descriptions)
map("n", "<leader>wv", "<cmd>vsplit<CR>", { silent = true, desc = "Split vertical" })
map("n", "<leader>ws", "<cmd>split<CR>", { silent = true, desc = "Split horizontal" })
map("n", "<leader>wc", "<cmd>close<CR>", { silent = true, desc = "Close window" })
map("n", "<leader>wo", "<cmd>only<CR>", { silent = true, desc = "Close others" })
map("n", "<leader>wh", "<C-w>h", { silent = true, desc = "Move left" })
map("n", "<leader>wj", "<C-w>j", { silent = true, desc = "Move down" })
map("n", "<leader>wk", "<C-w>k", { silent = true, desc = "Move up" })
map("n", "<leader>wl", "<C-w>l", { silent = true, desc = "Move right" })

-- Escape terminal mode
map("t", "<Esc>", "<C-\\><C-n>", opts)

-- Clear search with Esc (not terminal mode — handled by above)
map("n", "<Esc>", "<cmd>nohlsearch<CR>", opts)

-- Better page navigation
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)

-- File explorer (oil.nvim)
map("n", "<leader>e", "<cmd>Oil<CR>", { desc = "Open file explorer" })

-- Telescope (fuzzy finder)
map("n", "<leader><leader>", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files (alt)" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help tags" })
map("n", "<leader>fs", "<cmd>Telescope grep_string<CR>", { desc = "Grep word under cursor" })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "Recent files" })

-- OpenCode
map({ "n", "x" }, "<C-a>", function()
  require("opencode").ask("@this: ", { submit = true })
end, { desc = "Ask openCode" })
map({ "n", "x" }, "<C-x>", function()
  require("opencode").select()
end, { desc = "OpenCode actions" })
map("n", "<leader>oo", function()
  require("opencode").toggle()
end, { desc = "Toggle OpenCode" })

-- Plugins -------------------------------------------------------------------
require("lazy").setup({
  -- Colorscheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },

  -- Smooth cursor animation
  {
    "sphamba/smear-cursor.nvim",
    opts = {},
  },

  -- Keymap explorer (shows available keymaps while typing)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Fuzzy finder — the heart of navigation
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
        cond = function()
          return vim.fn.executable("cmake") == 1
        end,
      },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          mappings = {
            i = {
              -- Use j/k to navigate results in insert mode
              ["<C-j>"] = "move_selection_next",
              ["<C-k>"] = "move_selection_previous",
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            file_ignore_patterns = { "node_modules", ".git", ".DS_Store", "dist", "build", ".turbo" },
          },
          buffers = {
            sort_lastused = true,
            ignore_current_buffer = false,
            path_display = { "smart" },
            entry_format = "{filename}",
          },
        },
      })
      pcall(telescope.load_extension, "fzf")
    end,
  },

  -- File explorer — edit directories as buffers (hjkl friendly)
  -- Loads at startup so it can intercept nvim . and :e <dir>
  {
    "stevearc/oil.nvim",
    lazy = false,
    opts = {
      default_file_explorer = true,
      columns = { "icon" },
      keymaps = {
        ["l"] = "actions.select",
        ["h"] = "actions.parent",
      },
      view_options = {
        show_hidden = true,
      },
    },
  },

  -- Syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.config").setup({
        ensure_installed = {
          "lua", "vim", "vimdoc", "query",
          "javascript", "typescript", "html", "css", "json",
          "yaml", "markdown", "bash", "diff",
        },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- Git signs in the gutter
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
    },
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "catppuccin/nvim" },
    config = function()
      require("lualine").setup({
        options = {
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = {
            { "mode" },
          },
          lualine_b = {
            { "branch" },
          },
          lualine_c = {
            {
              function()
                if vim.bo.buftype == "terminal" then
                  return ""
                end
                if vim.bo.filetype == "oil" then
                  local name = vim.api.nvim_buf_get_name(0)
                  local path = name:gsub("^oil://", "")
                  local parts = vim.split(path, "/")
                  if #parts <= 2 then
                    return path
                  end
                  return parts[#parts - 1] .. "/" .. parts[#parts]
                end
                local dir = vim.fn.expand("%:.:h")
                local file = vim.fn.expand("%:t")
                if dir == "" or dir == "." then
                  return file
                end
                local parts = vim.split(dir, "/")
                if #parts <= 2 then
                  return dir .. "/" .. file
                end
                return parts[#parts - 1] .. "/" .. file
              end,
            },
          },
          lualine_x = {
            { "encoding" },
            { "fileformat" },
            { "filetype" },
          },
          lualine_y = {
            { "progress" },
          },
          lualine_z = {
            { "location" },
          },
        },
      })
    end,
  },

  -- Session persistence — keep buffers and windows between restarts
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      need = 0, -- guarda siempre (no requiere mínimo de buffers)
    },
    config = function(_, opts)
      require("persistence").setup(opts)

      -- Auto-load on startup (el config corre en BufReadPre, temprano pero después de VimEnter)
      if vim.fn.isdirectory(".git") == 1 then
        local persistence = require("persistence")
        local session_file = persistence.current()
        local had_opencode = false

        -- Checkear si opencode estaba abierto en la sesión guardada
        if vim.fn.filereadable(session_file) == 1 then
          local f = io.open(session_file, "r")
          if f then
            had_opencode = f:read("*a"):find("opencode") ~= nil
            f:close()
          end
        end

        pcall(persistence.load)

        -- Limpiar buffers fantasma de opencode (terminal sin proceso)
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.bo[buf].buftype == "terminal" then
            local name = vim.api.nvim_buf_get_name(buf)
            local status = vim.fn.term_getstatus(buf)
            if name:match("term://.*opencode") and (type(status) ~= "string" or not status:match("running")) then
              vim.api.nvim_buf_delete(buf, { force = true })
            end
          end
        end

        -- Reabrir opencode si estaba abierto al guardar la sesión
        if had_opencode then
          require("opencode").toggle()
        end
      end

      -- <leader>qs → restore last session (manual override)
      vim.keymap.set("n", "<leader>qs", function()
        require("persistence").load()
      end, { desc = "Restore session" })
    end,
  },

  -- OpenCode integration — talk to opencode from inside nvim
  {
    "nickjvandyke/opencode.nvim",
    config = function()
      vim.g.opencode_opts = {
        events = {
          permissions = {
            enabled = false, -- No molestar con popups; responder desde la TUI
          },
        },
      }
    end,
  },
})
