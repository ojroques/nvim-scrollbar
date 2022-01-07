-- nvim-scrollbar
-- By Olivier Roques
-- github.com/ojroques

-------------------- VARIABLES -----------------------------
local namespace = vim.api.nvim_create_namespace('scrollbar')
local state = {
  win_height = -1,
  nb_lines = -1,
  nb_visible_lines = -1,
  first_visible_line = -1,
  last_visible_line = -1,
  bar_size = -1,
  bin_size = -1,
  bin_start = -1,
}
local M = {}

-------------------- OPTIONS -------------------------------
M.options = {
  symbol_bar = {' ', 'TermCursor'},  -- The bar symbol and highlight group
  symbol_track = {},                 -- The track symbol and highlight group
  render_events = {                  -- Events triggering the redraw of the bar
    'BufWinEnter',
    'CmdwinLeave',
    'TabEnter',
    'TermEnter',
    'TextChanged',
    'VimResized',
    'WinEnter',
    'WinScrolled',
  },
}

-------------------- HELPERS -------------------------------
local function same_nb_lines()
  return vim.api.nvim_buf_line_count(0) == state.nb_lines
end

local function same_window()
  local same_head = vim.fn.line('w0') - 1 == state.first_visible_line
  local same_tail = vim.fn.line('w$') - 1 == state.last_visible_line
  return same_head and same_tail
end

-------------------- SCROLLBAR -----------------------------
local function is_excluded(bufnr)
  return vim.fn.buflisted(bufnr) == 0 or vim.fn.getbufvar(bufnr, '&filetype') == 'qf'
end

local function get_bin_size(win_height, nb_lines)
  local bin_size = math.floor(nb_lines / win_height + 0.5)
  if bin_size < 1 then
    bin_size = 1
  end
  return bin_size
end

local function get_bin_start(win_height, bin_size, first_visible_line)
  local bin_start = math.floor(first_visible_line / bin_size)
  if bin_start > win_height - 1 then
    bin_start = win_height - 1
  end
  return bin_start
end

local function get_bar_size(win_height, nb_lines, nb_visible_lines)
  return math.floor(win_height * (nb_visible_lines / nb_lines) + 0.5)
end

local function draw_bar(s)
  local opts_bar = {virt_text = {M.options.symbol_bar}, virt_text_pos = 'right_align'}
  local opts_track = {virt_text = {M.options.symbol_track}, virt_text_pos = 'right_align'}
  local start_line = s.first_visible_line + s.bin_start

  -- Clear scrollbar
  vim.api.nvim_buf_clear_namespace(0, namespace, 0, -1)

  -- Draw bar
  for line = start_line, start_line + s.bar_size do
    if line > s.nb_lines - 1 then
      break
    end
    vim.api.nvim_buf_set_extmark(0, namespace, line, -1, opts_bar)
  end

  -- Draw track
  if M.options.symbol_track and not vim.tbl_isempty(M.options.symbol_track) then
    for i = s.first_visible_line, s.last_visible_line do
      if i < start_line or i > start_line + s.bar_size then
        vim.api.nvim_buf_set_extmark(0, namespace, i, -1, opts_track)
      end
    end
  end
end

function M.render()
  if is_excluded(vim.fn.bufnr()) then
    vim.api.nvim_buf_clear_namespace(0, namespace, 0, -1)
    return
  end

  state.win_height = vim.api.nvim_win_get_height(0)

  if vim.fn.line('w$') < vim.fn.line('w0') then
    draw_bar(state)
    return
  end

  if same_nb_lines() and same_window() then
    draw_bar(state)
    return
  end

  if not same_nb_lines() then
    state.nb_lines = vim.api.nvim_buf_line_count(0)
    state.bin_size = get_bin_size(state.win_height, state.nb_lines)
  end

  if not same_window() then
    state.first_visible_line = vim.fn.line('w0') - 1
    state.last_visible_line = vim.fn.line('w$') - 1
    state.nb_visible_lines = state.last_visible_line - state.first_visible_line + 1
  end

  state.bin_start = get_bin_start(state.win_height, state.bin_size, state.first_visible_line)
  state.bar_size = get_bar_size(state.win_height, state.nb_lines, state.nb_visible_lines)

  draw_bar(state)
end

-------------------- SETUP -----------------------------
local function set_scrollbar()
  local fmt_string = 'autocmd %s * lua require("scrollbar").render()'
  vim.cmd('augroup scrollbar')
  vim.cmd('autocmd!')
  vim.cmd(string.format(fmt_string, table.concat(M.options.render_events, ',')))
  vim.cmd('augroup END')
end

function M.setup(user_options)
  if user_options then
    M.options = vim.tbl_extend('force', M.options, user_options)
  end
  set_scrollbar()
end

------------------------------------------------------------
return M
