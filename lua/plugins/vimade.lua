--- This plugins dims panes that are not active
return {
  'tadaa/vimade',
  event = 'VeryLazy',
  opts = {
    -- Removes line numbers etc
    recipe = { 'minimalist' },

    -- basebg is used to make dimmed windows look better with transparent themes
    -- checkout the guide in the documentation for how to pick a good color
    basebg = { 57, 56, 77 },

    -- Nicer style for inactive pane
    tint = {
      fg = { rgb = { 200, 200, 200 }, intensity = 0.5 },
    },
    fadelevel = 0.6,
  },
}
