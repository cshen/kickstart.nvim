return {
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {
      indent = {
        -- CS:  8-Oct-2024 23:01 I do not know how to change the color, so disable the indent line. Too bright
        char = '.',
        tab_char = '.',
      },
    },
  },
}
