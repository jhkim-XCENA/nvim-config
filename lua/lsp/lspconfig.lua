-- lua/lsp/lspconfig.lua

-- 1. LSP Keymaps (LSP가 연결되면 자동으로 키맵 적용)
-- v0.11부터는 이 방식이 표준이며, 변경되지 않았습니다.
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
    callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }
        local keymap = vim.keymap.set

        -- 키 매핑
        keymap('n', 'gD', vim.lsp.buf.declaration, opts)     -- 선언으로 이동
        keymap('n', 'gd', vim.lsp.buf.definition, opts)      -- 정의로 이동
        keymap('n', 'K', vim.lsp.buf.hover, opts)            -- 설명 보기
        keymap('n', 'gi', vim.lsp.buf.implementation, opts)  -- 구현체 보기
        keymap('n', '<space>rn', vim.lsp.buf.rename, opts)   -- 이름 변경
        keymap('n', '<space>ca', vim.lsp.buf.code_action, opts) -- 코드 액션
        keymap('n', 'gr', vim.lsp.buf.references, opts)      -- 참조 찾기
        
        -- 포맷팅
        keymap('n', '<space>f', function()
            vim.lsp.buf.format { async = true }
        end, opts)
    end,
})

-- 2. 서버 설정 (Native v0.11 Style)
-- 주의: require('lspconfig').setup 방식은 폐기되었습니다.
-- 대신 vim.lsp.config 테이블을 수정하고 vim.lsp.enable을 호출합니다.

-- [C/C++] clangd
vim.lsp.config.clangd = {
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
    },
}
vim.lsp.enable("clangd") -- 서버 활성화

-- [Rust] rust_analyzer
vim.lsp.config.rust_analyzer = {
    settings = {
        ["rust-analyzer"] = {
            checkOnSave = {
                command = "clippy",
            },
        },
    },
}
vim.lsp.enable("rust_analyzer")

-- [Python] pyright (필요시 주석 해제)
-- vim.lsp.enable("pyright")

-- [Lua] lua_ls (Neovim 설정용)
vim.lsp.config.lua_ls = {
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = { 'vim' } },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false, 
            },
            telemetry = { enable = false },
        },
    },
}
vim.lsp.enable("lua_ls")
