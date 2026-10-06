return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false, -- the `main` branch does not support lazy-loading
    build = ':TSUpdate',
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter-intro`
    config = function()
      require('nvim-treesitter').setup {
        install_dir = vim.fn.stdpath('data') .. '/site',
      }

      -- Ensure basic parsers are installed
      local parsers = {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
      }
      require('nvim-treesitter').install(parsers)

      ---@param buf integer
      ---@param language string
      local function try_attach(buf, language)
        -- The buffer may have been wiped while the parser was being installed
        if not vim.api.nvim_buf_is_valid(buf) then
          return
        end

        -- Check if a parser exists and load it
        if not vim.treesitter.language.add(language) then
          return
        end

        -- Enable syntax highlighting
        vim.treesitter.start(buf, language)

        -- Enable treesitter based indentation when an indent query is available.
        -- Without one, the indentexpr falls back to Vim's built-in behavior.
        if vim.treesitter.query.get(language, 'indents') ~= nil then
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end

      local available_parsers = require('nvim-treesitter').get_available()
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('kickstart-treesitter', { clear = true }),
        callback = function(args)
          local buf, filetype = args.buf, args.match

          local language = vim.treesitter.language.get_lang(filetype)
          if not language then
            return
          end

          local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

          if vim.tbl_contains(installed_parsers, language) then
            -- Parser is already installed
            try_attach(buf, language)
          elseif vim.tbl_contains(available_parsers, language) then
            -- Auto-install the parser, then attach once it is ready
            require('nvim-treesitter').install(language):await(function()
              try_attach(buf, language)
            end)
          else
            -- Parser may exist outside of nvim-treesitter, try to attach anyway
            try_attach(buf, language)
          end
        end,
      })
    end,
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: See `:help treesitter-incremental-selection`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },
}
-- vim: ts=2 sts=2 sw=2 et
