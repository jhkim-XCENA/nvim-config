-- ~/.config/nvim/init.lua

-- 1. Basic Options (UI & Behavior)
vim.g.mapleader = " "         -- Leader key를 Space로 설정 (매우 중요)
vim.g.maplocalleader = "\\"

local opt = vim.opt

opt.number = true             -- 줄 번호 표시
opt.relativenumber = false    -- 상대 라인 번호 끄기 (취향)
opt.cursorline = true         -- 현재 줄 강조
opt.tabstop = 4               -- 탭 크기 (C++ 표준 4칸 추천, 원하면 2로 변경)
opt.shiftwidth = 4            -- 들여쓰기 크기
opt.expandtab = true          -- 탭을 스페이스로 변환
opt.autoindent = true         -- 자동 들여쓰기
opt.smartindent = true        -- 스마트 들여쓰기
opt.wrap = false              -- 줄바꿈 안 함
opt.ignorecase = true         -- 검색 시 대소문자 무시
opt.smartcase = true          -- 대문자 섞이면 대소문자 구분
opt.termguicolors = true      -- 24bit 트루컬러 사용
opt.scrolloff = 8             -- 스크롤 시 위아래 여백 확보
opt.updatetime = 50           -- 반응 속도 (기본 4000ms -> 50ms)

-- Swap/Undo 설정
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("state") .. "/undo"

-- 2. Bootstrap Lazy.nvim (The modern plugin manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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

-- 3. Load Plugins & Configs
require("lazy").setup({
    spec = {
        -- 플러그인 명세를 별도 파일로 분리하여 로드
        { import = "plugins" },
    },
    checker = { enabled = true }, -- 플러그인 업데이트 자동 확인
})

-- 4. Load Extra Configs (LSP, Treesitter 등은 플러그인 파일에서 로드되지만 명시적 로드 필요 시)
-- Lazy.nvim 방식에서는 보통 plugins/ 폴더 내에서 config() 함수로 처리하는 것이 깔끔합니다.
-- 하지만 기존 구조를 유지하기 위해 아래 require를 유지하되, 내용은 Lazy spec에 맞게 수정했습니다.
