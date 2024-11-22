local function command(name, desc, cmd, opts)
  opts = opts or {}
  opts.desc = desc
  vim.api.nvim_create_user_command(name, cmd, opts)
end

local function filter_qf()
  vim.cmd("packadd cfilter")
  vim.cmd([[Cfilter! "bin/\|build/"]])
end

command("SudoWrite", "Save file as SU", "execute 'silent! write !sudo tee % > /dev/null' | edit!")

command("VennToggle", "Toggle Venn", function() require("my.functions").toggle_venn() end)

command("Hints", "Add reported LSP hints to the quickfix list",
  function()
    vim.diagnostic.setqflist({
      title = "Hints",
      severity = vim.diagnostic.severity.HINT
    })

    filter_qf()
  end
)

command("Warnings", "Add reported LSP warnings to the quickfix list",
  function()
    vim.diagnostic.setqflist({
      title = "Warnings",
      severity = vim.diagnostic.severity.WARN
    })

    filter_qf()
  end
)

command("Errors", "Add reported LSP errors to the quickfix list",
  function()
    vim.diagnostic.setqflist({
      title = "Errors",
      severity = vim.diagnostic.severity.ERROR
    })

    filter_qf()
  end
)

command("Redir", "Redirect command output to a new buffer",
  function(ctx)
    local lines = vim.split(vim.api.nvim_exec(ctx.args, true), "\n", { plain = true })
    vim.cmd("new")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.opt_local.modified = false
  end,
  { nargs = "+", complete = "command" }
)

vim.cmd("cnoreabbrev hints Hints")
vim.cmd("cnoreabbrev warnings Warnings")
vim.cmd("cnoreabbrev errors Errors")
vim.cmd("cnoreabbrev wo WorkspacesOpen")
