return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  opts = {
    -- add any options here
  },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    'MunifTanjim/nui.nvim',
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    -- 'rcarriga/nvim-notify',
  },
  config = function()
    require('noice').setup {
      routes = {
        {
          filter = {
            -- Filter out 'No information available' which happens when using LSP hover in Typescript
            event = 'notify',
            find = 'No information available',
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = 'msg_show',
            any = {
              { find = '%d+L, %d+B' },
              -- Filter out spammy notifications when saving buffer
              { find = '; after #%d+' },

              { find = '; before #%d+' },
            },
          },
          view = 'mini',
        },
        -- Extra notify event when messages are not funneled through Noice
        {
          filter = { event = 'notify', min_height = 20 },
          view = 'cmdline_output',
        },
      },
      notify = {
        enable = true,
        view = 'notify',
      },
      lsp = {
        progress = {
          enabled = true,
          view = 'mini',
        },
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = true, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
    }
  end,
}
