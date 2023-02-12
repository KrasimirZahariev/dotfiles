local jdtls = require('jdtls')

local VCS_DIR = os.getenv("VCS_DIR")
local LOMBOK_JAR = XDG_DATA_HOME..'/lombok/lombok.jar'
local LS_JAR = vim.fn.glob('/usr/share/java/jdtls/plugins/org.eclipse.equinox.launcher_*.jar')
local CONFIG_DIR = "/usr/share/java/jdtls/config_linux"
local PROJECT_DIR = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local PROJECT_DATA_DIR = NVIM_CACHE_HOME.."/ws-"..PROJECT_DIR
local JAVA_DEBUG_JAR =
  VCS_DIR.."/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"
local VSCODE_JAVA_TEST_JAR = VCS_DIR.."/vscode-java-test/server/*.jar"

local function get_cmd()
  return {
    'java',
    '-javaagent:'..LOMBOK_JAR,
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms512M',
    '-Xmx1G',
    '-jar', LS_JAR,
    '-configuration', CONFIG_DIR,
    '-data', PROJECT_DATA_DIR,
    '--add-modules=ALL-SYSTEM',
    '--add-opens java.base/java.util=ALL-UNNAMED',
    '--add-opens java.base/java.lang=ALL-UNNAMED'
  }
end

local settings = {
  java = {
    signatureHelp = {
      enabled = true
    },

    contentProvider = {
      preferred = 'fernflower'
    },

    completion = {
      favoriteStaticMembers = {
        'org.assertj.core.api.Assertions.assertThat',
        'org.junit.jupiter.api.Assertions.*',
        'org.mockito.Mockito.*'
      },
      -- importOrder = {
      --   "java",
      --   "javax",
      --   "com",
      --   "org"
      -- }
    },

    sources = {
      organizeImports = {
        starThreshold = 9999,
        staticStarThreshold = 9999
      }
    },

    -- saveActions = {
    --   organizeImports = true,
    -- },

    codeGeneration = {
      toString = {
        template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
      },
      useBlocks = true
    },

    configuration = {
      maven = {
        userSettings = XDG_CONFIG_HOME..'/maven/settings.xml'
      }
    }

  }
}

local function get_flags(base_flags)
  base_flags.server_side_fuzzy_completion = true
  return base_flags;
end

local function handle_hover(_, result, ctx)
  if vim.api.nvim_get_current_buf() ~= ctx.bufnr
    or not (result and result.contents)
  then
    return
  end

  local util = vim.lsp.util

  local markdown_lines = util.convert_input_to_markdown_lines(result.contents, _)
  markdown_lines = util.trim_empty_lines(markdown_lines)
  if vim.tbl_isempty(markdown_lines) then
    vim.notify('No information available')
    return
  end

  local config = {
    border = "rounded",
    focus_id = ctx.method,
  }

  local bufnr, winnr = util.open_floating_preview(markdown_lines, "markdown", config)
  vim.api.nvim_buf_set_option(bufnr, "filetype", "markdown")

  return bufnr, winnr
end

local function get_handlers(base_handlers)
  base_handlers["textDocument/hover"] = handle_hover
  return base_handlers
end

local function get_bundles()
  local bundles = { vim.fn.glob(JAVA_DEBUG_JAR, true) };
  vim.list_extend(bundles, vim.split(vim.fn.glob(VSCODE_JAVA_TEST_JAR, true), "\n"))
  return bundles
end

local function get_extended_client_capabilities()
  local extendedClientCapabilities = jdtls.extendedClientCapabilities;
  extendedClientCapabilities.resolveAdditionalTextEditsSupport = true;
  return extendedClientCapabilities
end

local function get_init_options()
  return {
    bundles = get_bundles();
    extendedClientCapabilities = get_extended_client_capabilities();
  }
end

local function java_on_attach(base_on_attach)
  return function(client, bufnr)
    base_on_attach(client, bufnr)

    -- register java debug adapter
    jdtls.setup_dap({hotcodereplace = "auto"})

    -- needs to be after jdtls.setup_dap, so that debugging related cmds are included
    jdtls.setup.add_commands()

    require("my.private")
    require("my.mappings").jdtls(bufnr)

    vim.schedule(function()
      require("jdtls.dap").setup_dap_main_class_configs()
    end)
  end
end

local function get_config()
  local base_config = require("my.lsp").get_config()

  return {
    root_dir = jdtls.setup.find_root({"gradlew"}),
    cmd = get_cmd(),
    settings = settings,
    flags = get_flags(base_config.flags),
    handlers = get_handlers(base_config.handlers),
    capabilities = base_config.capabilities,
    init_options = get_init_options(),
    on_init = base_config.on_init,
    on_attach = java_on_attach(base_config.on_attach),
  }
end

jdtls.start_or_attach(get_config())
