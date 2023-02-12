local M = {}

local functions = require("my.functions")
local mappings  = require("my.mappings")
local settings  = require("my.settings")

local AUGROUP_VIMRC = vim.api.nvim_create_augroup("vimrc", {clear = true})

local BUF_ENTER        = "BufEnter"
local BUF_READ_POST    = "BufReadPost"
local BUF_WRITE_PRE    = "BufWritePre"
local BUF_WRITE_POST   = "BufWritePost"
local BUF_MODIFIED_SET = "BufModifiedSet"
local TEXT_YANK_POST   = "TextYankPost"
local TEXT_CHANGED     = "TextChanged"
local TEXT_CHANGED_I   = "TextChangedI"
local INSERT_LEAVE     = "InsertLeave"
local FILE_TYPE        = "FileType"
local CURSOR_HOLD      = "CursorHold"
local CURSOR_HOLD_I    = "CursorHoldI"
local CURSOR_MOVED     = "CursorMoved"
local CURSOR_MOVED_I   = "CursorMovedI"
local CMD_LINE_LEAVE   = "CmdLineLeave"

local function autocmd(desc, events, opts)
  if opts.group == nil then
    opts.group = AUGROUP_VIMRC
  end
  opts.desc = desc
  vim.api.nvim_create_autocmd(events, opts)
end

autocmd("Highlight yank",
  TEXT_YANK_POST, {
    pattern = "*",
    callback = function() vim.highlight.on_yank({higroup="Search", timeout=150}) end
  }
)

autocmd("When opening a file, jump to the last known cursor position",
  BUF_READ_POST, {
    pattern = "*",
    callback = functions.jump_to_last_position
  }
)

autocmd("Reaload config on save",
  BUF_WRITE_POST, {
    pattern = {
      XDG_CONFIG_HOME.."/i3/config",
      XDG_CONFIG_HOME.."/polybar/config",
      XDG_CONFIG_HOME.."/tmux/tmux.conf"
    },
    callback = function(data) functions.reload_config(data.match) end
  }
)

autocmd("Disable automatic commenting on newline",
  BUF_ENTER, {
    pattern = "*",
    callback = settings.set_formatoptions
  }
)

autocmd("Delete trailing whitespaces and new lines on save",
  BUF_WRITE_PRE, {
    pattern = "*",
    callback = functions.delete_trailing_ws_nl
  }
)

autocmd("Undotree specific mappings",
  FILE_TYPE, {
    pattern = "undotree",
    callback = mappings.undotree
  }
)

autocmd("Less syntax highlight for long XML lines",
  FILE_TYPE, {
    pattern = "xml",
    callback = settings.set_xml_options
  }
)

autocmd("Set packer options",
  FILE_TYPE, {
    pattern = "packer",
    callback = settings.set_packer_options
  }
)

autocmd("Plugins snapshot after packer update",
  "User", {
    pattern = "PackerComplete",
    callback = function()
      local snapshot_name = os.date("%Y_%m_%d_%H_%M")..".snapshot"
      require("packer").snapshot(snapshot_name)
    end
  }
)

autocmd("Clear cmdline 3 secs after entering command",
  CMD_LINE_LEAVE, {
    pattern = "*",
    callback = function()
      vim.defer_fn(function() vim.cmd(":echo") end, 3000)
    end
  }
)

autocmd("Quit vim if the last remaining buffer is NvimTree",
  BUF_ENTER, {
    pattern = "NvimTree*",
    callback = function()
      local layout = vim.api.nvim_call_function("winlayout", {})
      if layout[1] == "leaf"
          and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype") == "NvimTree"
          and layout[3] == nil then

        vim.cmd("confirm quit")
      end
    end
  }
)

autocmd("sql mappings",
  FILE_TYPE, {
    pattern = "sql",
    callback = function(data)
      require("my.private.db").setup(data)
    end,
  }
)

autocmd("dbui mappings",
  FILE_TYPE, {
    pattern = 'dbui',
    callback = mappings.dbui
  }
)

autocmd("dbout mappings",
  FILE_TYPE, {
    pattern = 'dbout',
    callback = mappings.dbout
  }
)

function M.lsp(client, bufnr)
  if client.server_capabilities['documentHighlightProvider'] then
    autocmd("Highlight lsp references",
      {CURSOR_HOLD, CURSOR_HOLD_I}, {
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight
      }
    )

    autocmd("Clear highlighted references",
      {CURSOR_MOVED, CURSOR_MOVED_I}, {
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references
      }
    )
  end

  autocmd("Code action menu specific mappings",
    FILE_TYPE, {
      pattern = "code-action-menu-menu",
      callback = mappings.nvim_code_action_menu
    }
  )

  if vim.lsp.codelens and client.server_capabilities['codeLensProvider'] then
    autocmd("Refresh lsp codelens wrapper",
      FILE_TYPE, {
        pattern = "rust",
        callback = function()
            autocmd("Refresh lsp codelens",
              {BUF_ENTER, BUF_MODIFIED_SET, INSERT_LEAVE}, {
                buffer = bufnr,
                callback = vim.lsp.codelens.refresh
              }
            )
          end
      }
    )
  end

  autocmd("Draw column if line is too long",
    {BUF_ENTER, TEXT_CHANGED, TEXT_CHANGED_I}, {
      buffer = bufnr,
      callback = function() functions.draw_column_line(110) end
    }
  )

  -- autocmd("Autocomplete in dap-repl",
  --   FILE_TYPE, {
  --     pattern = "dap-repl",
  --     callback = require("dap.ext.autocompl").attach
  --   }
  -- )

  autocmd("close dap-repl",
    FILE_TYPE, {
      pattern = 'dap-repl',
      callback = function ()
        vim.cmd("bd")
      end
    }
  )
end

return M
