local function command(name, desc, cmd, opts)
  opts = opts or {}
  opts.desc = desc
  vim.api.nvim_create_user_command(name, cmd, opts)
end

command("SudoWrite", "Save file as SU", "execute 'silent! write !sudo tee % > /dev/null' | edit!")

command("VennToggle", "Toggle Venn", function() require("my.functions").toggle_venn() end)

command("Hints", "Add reported LSP hints to the quickfix list",
  function()
    vim.diagnostic.setqflist({
      title = "Hints",
      severity = vim.diagnostic.severity.HINT
    })
  end
)

command("Warnings", "Add reported LSP warnings to the quickfix list",
  function()
    vim.diagnostic.setqflist({
      title = "Warnings",
      severity = vim.diagnostic.severity.WARN
    })
  end
)

command("Errors", "Add reported LSP errors to the quickfix list",
  function()
    vim.diagnostic.setqflist({
      title = "Errors",
      severity = vim.diagnostic.severity.ERROR
    })
  end
)

vim.cmd("cnoreabbrev bcl BufferLineCloseLeft")
vim.cmd("cnoreabbrev bcr BufferLineCloseRight")
vim.cmd("cnoreabbrev pu PackerUpdate")
vim.cmd("cnoreabbrev pc PackerCompile")
