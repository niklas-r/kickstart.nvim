return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  opts = {
    suggestion = { enabled = false },
    panel = { enabled = false },
    filetypes = {
      bigfile = false,
    },
  },
  dependencies = {},
}
