return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    {
      'bwpge/lualine-pretty-path',
      'folke/snacks.nvim',
      -- I use this plugin to set my theme and lualine does some shenangians with themes so
      -- we need to wait for it to load
      'propet/colorscheme-persist.nvim',
      -- dev = true,
    },
  },
  -- config = function(_, opts)
  opts = function()
    local lazy_status = require 'lazy.status' -- to configure lazy pending updates count

    --- From: https://github.com/nvim-lualine/lualine.nvim/wiki/Component-snippets
    --- @param trunc_width number trunctates component when screen width is less then trunc_width
    --- @param trunc_len number truncates component to trunc_len number of chars
    --- @param hide_width number hides component when window width is smaller then hide_width
    --- @param no_ellipsis boolean whether to disable adding '...' at end after truncation
    --- return function that can format the component accordingly
    local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
      return function(str)
        local win_width = vim.fn.winwidth(0)
        if hide_width and win_width < hide_width then
          return ''
        elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
          return str:sub(1, trunc_len) .. (no_ellipsis and '' or '…')
        end
        return str
      end
    end

    -- Show LSP status, borrowed from Heirline cookbook
    -- https://github.com/rebelot/heirline.nvim/blob/master/cookbook.md#lsp
    local function lsp_status_all()
      local haveServers = false
      local names = {}
      for _, server in pairs(vim.lsp.get_clients { bufnr = 0 }) do
        haveServers = true
        table.insert(names, server.name)
      end
      if not haveServers then
        return ''
      end
      if vim.g.custom_lualine_show_lsp_names then
        return ' ' .. table.concat(names, ',')
      end
      return ' '
    end

    -- Override 'encoding': Don't display if encoding is UTF-8.
    local encoding_only_if_not_utf8 = function()
      local ret, _ = (vim.bo.fenc or vim.go.enc):gsub('^utf%-8$', '')
      return ret
    end
    -- fileformat: Don't display if &ff is unix.
    local fileformat_only_if_not_unix = function()
      local ret, _ = vim.bo.fileformat:gsub('^unix$', '')
      return ret
    end

    -- Toggling vim.b.trouble_lualine doesn't seem to do anything and I don't really want to toggle it anyway
    -- snacks
    --   .toggle({
    --     name = 'lualine symbols',
    --     get = function()
    --       return vim.b.trouble_lualine ~= false
    --     end,
    --     set = function(state)
    --       vim.b.trouble_lualine = state
    --     end,
    --   })
    --   :map '<leader>tS'

    Snacks.toggle({
      name = 'lualine lsp names',
      get = function()
        return vim.g.custom_lualine_show_lsp_names
      end,
      set = function(state)
        vim.g.custom_lualine_show_lsp_names = state
      end,
    }):map '<leader>tN'

    return {
      options = {
        component_separators = { left = '╲', right = '╱' },
        disabled_filetypes = { 'alpha', 'neo-tree', 'snacks_dashboard' },
        section_separators = { left = '', right = '' },
        ignore_focus = { 'trouble' },
        always_show_tabline = false,
      },
      sections = {
        lualine_a = {
          {
            'mode',
            fmt = trunc(130, 3, 0, true),
          },
        },
        lualine_b = {
          {
            'branch',
            fmt = trunc(70, 15, 65, true),
            separator = '',
          },

          {
            'diff',
            symbols = {
              added = ' ',
              modified = ' ',
              removed = ' ',
            },
            fmt = trunc(0, 0, 60, true),
          },
          {
            'diagnostics',
            symbols = vim.g.have_nerd_font and { error = ' ', warn = ' ', info = ' ', hint = ' ' }
              or { error = 'E', warn = 'W', info = 'I', hint = 'H' },
          },
        },
        lualine_c = {
          {
            'pretty_path',
            providers = {
              default = require 'util/pretty_path_harpoon',
            },
            directories = {
              max_depth = 4,
            },
            highlights = {
              newfile = 'LazyProgressDone',
            },
            separator = '',
          },
        },
        lualine_x = {
          {
            function()
              return vim.g.macro_recording
            end,
            cond = function()
              return vim.g.macro_recording ~= nil
            end,
            color = 'DiagnosticVirtualTextHint',
            separator = { left = '', right = '' },
          },
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            -- color = { fg = '#3d59a1' },
            fmt = trunc(0, 0, 160, true), -- hide when window is < 100 columns
            separator = '',
          },

          require('util.lualine').cmp_source('copilot', ''),

          {
            lsp_status_all,
            fmt = trunc(0, 8, 140, false),
            separator = '',
          },
          {
            encoding_only_if_not_utf8,
            fmt = trunc(0, 0, 140, true), -- hide when window is < 80 columns
            separator = '',
          },
          {
            fileformat_only_if_not_unix,
            fmt = trunc(0, 0, 140, true), -- hide when window is < 80 columns
            separator = '',
          },
        },
        lualine_y = {
          { 'progress', fmt = trunc(0, 0, 40, true) },
        },
        lualine_z = {
          { 'location', fmt = trunc(0, 0, 80, true) },
        },
      },
      tabline = {
        lualine_a = {
          {
            'tabs',
            mode = 1, -- 0: Shows tab_nr
            -- 1: Shows tab_name
            -- 2: Shows tab_nr + tab_name

            path = 0, -- 0: just shows the filename
            -- 1: shows the relative path and shorten $HOME to ~
            -- 2: shows the full path
            -- 3: shows the full path and shorten $HOME to ~
            show_modified_status = false,
          },
        },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      inactive_sections = {
        lualine_c = {
          {
            'pretty_path',
            -- 'filename',
            -- symbols = {
            --   modified = '+', -- Text to show when the file is modified.
            --   readonly = '', -- Text to show when the file is non-modifiable or readonly.
            -- },
          },
        },
      },
      winbar = {},
      extensions = {
        'lazy',
        'mason',
        'neo-tree',
        'nvim-dap-ui',
        'oil',
        'quickfix',
        'trouble',
      },
    }
  end,
}
