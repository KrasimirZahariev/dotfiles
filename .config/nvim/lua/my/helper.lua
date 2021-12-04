local api = vim.api

local M = {}

function M.map(lhs, rhs, opts, bufnr, mode)
  opts = opts or {}
  mode = mode or ''

  if bufnr then
    api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
  else
    api.nvim_set_keymap(mode, lhs, rhs, opts)
  end
end

function M.nmap(lhs, rhs, opts, bufnr)
  opts = opts or {}
  M.map(lhs, rhs, opts, bufnr, 'n' )
end

function M.nnoremap(lhs, rhs, opts, bufnr)
  opts = opts or {}
  opts.noremap = true
  M.nmap(lhs, rhs, opts, bufnr)
end

function M.imap(lhs, rhs, opts, bufnr)
  opts = opts or {}
  M.map(lhs, rhs, opts, bufnr, 'i')
end

function M.inoremap(lhs, rhs, opts, bufnr)
  opts = opts or {}
  opts.noremap = true
  M.imap(lhs, rhs, opts, bufnr)
end

function M.vmap(lhs, rhs, opts, bufnr)
  opts = opts or {}
  M.map(lhs, rhs, opts, bufnr, 'v')
end

function M.vnoremap(lhs, rhs, opts, bufnr)
  opts = opts or {}
  opts.noremap = true
  M.vmap(lhs, rhs, opts, bufnr)
end

function M.xmap(lhs, rhs, opts, bufnr)
  opts = opts or {}
  M.map(lhs, rhs, opts, bufnr, 'x')
end

function M.xnoremap(lhs, rhs, opts, bufnr)
  opts = opts or {}
  opts.noremap = true
  M.xmap(lhs, rhs, opts, bufnr)
end

function M.cmap(lhs, rhs, opts, bufnr)
  opts = opts or {}
  M.map(lhs, rhs, opts, bufnr, 'c')
end

function M.cnoremap(lhs, rhs, opts, bufnr)
  opts = opts or {}
  opts.noremap = true
  M.cmap(lhs, rhs, opts, bufnr)
end

function M.tmap(lhs, rhs, opts, bufnr)
  opts = opts or {}
  M.map(lhs, rhs, opts, bufnr, 't')
end

function M.tnoremap(lhs, rhs, opts, bufnr)
  opts = opts or {}
  opts.noremap = true
  M.tmap(lhs, rhs, opts, bufnr)
end

function M.set(option, value)
  if value == nil then
    vim.opt[option] = true
    return
  end

  if type(value) == 'number' or type(value) == 'boolean' then
    vim.opt[option] = value
    return
  end

  local operator = value:sub(1, 1);
  local valueSubStr = value:sub(2, value:len())

  if operator == '+' then
    vim.opt[option]:append(valueSubStr)
  elseif operator == '-' then
    vim.opt[option]:remove(valueSubStr)
  elseif operator == '^' then
    vim.opt[option]:prepend(valueSubStr)
  else
    vim.opt[option] = value
  end
end

-- execute sys command and get the output
function M.sys_exec(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()

  if raw then
    return s
  end

  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')

  return s
end


return M
