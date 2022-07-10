local M = {}

function M.map(mode, lhs, rhs, opts)
  mode = mode or ''
  opts = opts or {}
  opts.buffer = opts.buffer or false
  vim.keymap.set(mode, lhs, rhs, opts);
end

function M.nmap(lhs, rhs, opts)
  opts = opts or {}
  opts.remap = true
  M.map("n", lhs, rhs, opts)
end

function M.nnoremap(lhs, rhs, opts)
  M.map("n", lhs, rhs, opts)
end

function M.imap(lhs, rhs, opts)
  opts = opts or {}
  opts.remap = true
  M.map("i", lhs, rhs, opts)
end

function M.inoremap(lhs, rhs, opts)
  M.map("i", lhs, rhs, opts)
end

function M.vmap(lhs, rhs, opts)
  opts = opts or {}
  opts.remap = true
  M.map("v", lhs, rhs, opts)
end

function M.vnoremap(lhs, rhs, opts)
  M.map("v", lhs, rhs, opts)
end

function M.xmap(lhs, rhs, opts)
  opts = opts or {}
  opts.remap = true
  M.map("x", lhs, rhs, opts)
end

function M.xnoremap(lhs, rhs, opts)
  M.map("x", lhs, rhs, opts)
end

function M.cmap(lhs, rhs, opts)
  opts = opts or {}
  opts.remap = true
  M.map("c", lhs, rhs, opts)
end

function M.cnoremap(lhs, rhs, opts)
  M.map("c", lhs, rhs, opts)
end

function M.tmap(lhs, rhs, opts)
  opts = opts or {}
  opts.remap = true
  M.map("t", lhs, rhs, opts)
end

function M.tnoremap(lhs, rhs, opts)
  M.map("t", lhs, rhs, opts)
end


local function set_opt(option, value, set)
  if value == nil then
    set[option] = true
    return
  end

  if type(value) == 'number' or type(value) == 'boolean' then
    set[option] = value
    return
  end

  local operator = value:sub(1, 1);
  local valueSubStr = value:sub(2, value:len())

  if operator == '+' then
    set[option]:append(valueSubStr)
  elseif operator == '-' then
    set[option]:remove(valueSubStr)
  elseif operator == '^' then
    set[option]:prepend(valueSubStr)
  else
    set[option] = value
  end
end

function M.set(option, value)
  set_opt(option, value, vim.opt)
end

function M.setlocal(option, value)
  set_opt(option, value, vim.opt_local)
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
