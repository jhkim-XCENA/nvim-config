-- lua/lsp/lspconfig.lua
local lspconfig = require('lspconfig')

-- 자동 완성 플러그인 (예: nvim-cmp)에 LSP 기능을 연결하는 함수
local on_attach = function(client, bufnr)
    -- Lualine (상태 표시줄)에 현재 LSP 상태 표시
    if client.server_capabilities.documentSymbolProvider then
        -- nvim-cmp나 기타 LSP 플러그인이 여기서 추가 키맵이나 설정을 구성합니다.
        -- 예시: require('cmp').setup_buffer_settings(bufnr)
    end
    
    -- LSP 기본 키맵 설정 (Vim 사용자를 위한 gd, gr 등)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local opts = { noremap=true, silent=true }
    
    -- 정의/참조 내비게이션
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)          -- 정의로 이동
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)        -- 선언으로 이동
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)         -- 참조 찾기
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)               -- 문서 보기 (Hover)
    buf_set_keymap('n', 'gI', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)     -- 구현체로 이동

    -- 액션 및 진단
    buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts) -- Code Action
    buf_set_keymap('n', 'gR', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)             -- 이름 변경 (Rename)
    buf_set_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.format()<CR>', opts)       -- 포맷팅 (Format)
    
    -- 진단 (Diagnostics) 키맵
    buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)        -- 이전 문제로 이동
    buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)        -- 다음 문제로 이동
end

-- LSP 기본 설정 (모든 서버에 적용)
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- 1. clangd 설정 (C/C++ LSP)
lspconfig.clangd.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    -- C/C++ 프로젝트는 compile_commands.json 파일을 프로젝트 루트에 두는 것이 가장 좋으며, 
    -- clangd는 이를 자동으로 찾습니다.
    cmd = {'clangd'},
    filetypes = {'c', 'cpp', 'objc', 'objcpp', 'h', 'hpp', 'ino'},
    -- 추가 설정: 예를 들어, 특정 컴파일 플래그를 항상 추가하고 싶을 때
    settings = {
        clangd = {
            arguments = {
                '--clang-tidy',           -- clang-tidy 활성화
                '--all-scopes-completion',-- 모든 범위 완성 활성화
            }
        }
    }
}

-- 2. Lua Language Server 설정 (Neovim 설정 자체를 위한 LSP)
lspconfig.lua_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
            },
            diagnostics = {
                globals = {'vim'}, -- vim 전역 변수 인식
            },
            workspace = {
                -- Neovim 런타임 파일들을 인식하여 자동 완성 및 진단에 사용
                library = vim.api.nvim_get_runtime_file("", true),
                maxPreload = 100000,
                checkThirdParty = false,
            },
        },
    },
}

-- 기타 LSP 서버 (선택 사항):
-- lspconfig.pyright.setup { on_attach = on_attach, capabilities = capabilities }
-- lspconfig.tsserver.setup { on_attach = on_attach, capabilities = capabilities }
