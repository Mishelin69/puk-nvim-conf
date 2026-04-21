require("mishelin")

-- LSP Diagnostics Options Setup

require("mason").setup({
    registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
    },
})
require("mason-lspconfig").setup({
  ensure_installed = { "rust_analyzer", "clangd", "basedpyright", "roslyn", "ruff"},
})

vim.lsp.enable('clangd')

local function get_python_path(workspace)
  if vim.env.VIRTUAL_ENV then
    return vim.fs.joinpath(vim.env.VIRTUAL_ENV, 'bin', 'python')
  end

  local venv_path = vim.fs.joinpath(workspace, '.venv', 'bin', 'python')
  if vim.fn.executable(venv_path) == 1 then
    return venv_path
  end

  return vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python'
end

vim.lsp.config('basedpyright', {
  on_new_config = function(config, root_dir)
    config.settings.python.pythonPath = get_python_path(root_dir)
  end,
  
  settings = {
    python = {},
    basedpyright = {
      analysis = {
        typeCheckingMode = "basic", -- Options: "off", "basic", "standard", "strict"
        useLibraryCodeForTypes = true,
      }
    }
  }
})

vim.lsp.enable('basedpyright')

vim.lsp.config('ruff', {
  on_attach = function(client, bufnr)
    client.server_capabilities.hoverProvider = false
  end
})

vim.lsp.enable('ruff')

local cmp = require'cmp'

require("roslyn").setup({
    capabilities = cmp,
    
    config = {
        settings = {
            ["csharp|inlay_hints"] = {
                csharp_enable_inlay_hints_for_implicit_object_creation = true,
                csharp_enable_inlay_hints_for_implicit_variable_types = true,
                csharp_enable_inlay_hints_for_lambda_parameter_types = true,
                csharp_enable_inlay_hints_for_types = true,
            },
            ["csharp|code_lens"] = {
                dotnet_enable_references_code_lens = true,
            },
        },
    },
    
    exe = {
        "dotnet",
        vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "packages", "roslyn", "libexec", "Microsoft.CodeAnalysis.LanguageServer.dll"),
    },
})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local buffer = args.buf

        if client and client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
        end

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = buffer, desc = "Go to Definition" })
        vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = buffer, desc = "Go to References" })
    end,
})

vim.lsp.enable('rust_analyzer', {
  on_attach = function(client, bufnr)
    require("lsp-endhints").on_attach(bufnr)

    -- Keymaps
    vim.keymap.set("n", "<C-space>", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover" })
    vim.keymap.set("n", "<Leader>a", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code Action" })
  end,

  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      check = {
        command = "clippy",
        onSave = "on_change",
      },
      diagnostics = {
        enable = true,
        refreshRate = 200,
      },
      inlayHints = {
        enable = true,
        parameterHints = { enable = true },
        typeHints = { enable = false },
        chainingHints = { enable = false },
        closingBraceHints = { enable = false },
      },
    },
  },
})

require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        }
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {'filename'},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
}

local sign = function(opts)
    vim.fn.sign_define(opts.name, {
        texthl = opts.name,
        text = opts.text,
        numhl = ''
    })
end

sign({name = 'DiagnosticSignError', text = '⚠'})
sign({name = 'DiagnosticSignWarn', text = ''})
sign({name = 'DiagnosticSignHint', text = '❐'})
sign({name = 'DiagnosticSignInfo', text = ''})

vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    update_in_insert = true,
    underline = true,
    severity_sort = false,
    float = {
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
})

vim.cmd([[
set signcolumn=yes
set foldlevel=100
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])
-- Completion Plugin Setup
cmp.setup({
    -- Enable LSP snippets
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        -- Add tab support
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<C-S-f>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        })
    },
    -- Installed sources:
    sources = {
        { name = 'path' },                              -- file paths
        { name = 'nvim_lsp', keyword_length = 3 },      -- from language server
        { name = 'nvim_lsp_signature_help'},            -- display function signatures with current parameter emphasized
        { name = 'nvim_lua', keyword_length = 2},       -- complete neovim's Lua runtime API such vim.lsp.*
        { name = 'buffer', keyword_length = 2 },        -- source current buffer
        { name = 'vsnip', keyword_length = 2 },         -- nvim-cmp source for vim-vsnip 
        { name = 'calc'},                               -- source for math calculation
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    formatting = {
        fields = {'menu', 'abbr', 'kind'},
        format = function(entry, item)
            local menu_icon ={
                nvim_lsp = 'λ',
                vsnip = '⋗',
                buffer = 'Ω',
                path = '🖫',
            }
            item.menu = menu_icon[entry.source.name]
            return item
        end,
    },
})

-- Treesitter Plugin Setup 
require('nvim-treesitter.configs').setup {
    ensure_installed = { "lua", "rust", "toml", "python" },
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting=false,
    },
    ident = { enable = true }, 
    rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = nil,
    }
}


