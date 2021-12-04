local coq = require('coq')
local jdtls = require('jdtls')
local dap = require('jdtls.dap');
local mappings = require('lua.my.mappings')

local M = {}

local function get_cmd()
  local project_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

  local cmd = {'jdtls-start', project_dir}

  -- local XDG_DATA_HOME = os.getenv('XDG_DATA_HOME')
  -- local cmd = {
  --   '/usr/bin/java',
  --   '-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=1044',
  --   '-javaagent:' .. XDG_DATA_HOME .. '/lombok/lombok.jar',
  --   '-Xbootclasspath/a:' .. XDG_DATA_HOME .. '/lombok/lombok.jar',
  --   '-Declipse.application=org.eclipse.jdt.ls.core.id1',
  --   '-Dosgi.bundles.defaultStartLevel=4',
  --   '-Declipse.product=org.eclipse.jdt.ls.core.product',
  --   '-Dlog.protocol=true',
  --   '-Dlog.level=ALL',
  --   '-Xms256M',
  --   '-Xmx512M',
  --   '-jar /usr/share/java/jdtls/plugins/org.eclipse.equinox.launcher_*.jar',
  --   '-configuration ' .. XDG_DATA_HOME .. '/jdtls/config_linux',
  --   '-data ' .. '/tmp/ws-' .. project_dir,
  --   '--add-modules=ALL-SYSTEM',
  --   '--add-opens java.base/java.util=ALL-UNNAMED',
  --   '--add-opens java.base/java.lang=ALL-UNNAMED',
  -- }

  return cmd
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
        'org.junit.jupiter.api.Assertions.*',
        'org.assertj.core.api.Assertions.assertThat',
        'org.mockito.Mockito.*'
      }
    },

    sources = {
      organizeImports = {
        starThreshold = 9999,
        staticStarThreshold = 9999
      }
    },

    codeGeneration = {
      toString = {
        template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
      },
      useBlocks = true
    },

    configuration = {}
  }
}

local function get_flags(base_flags)
  base_flags.server_side_fuzzy_completion = true
  return base_flags;
end

local function get_bundles()
  local home = os.getenv('HOME')
  local jar_patterns = {
    '/vcs/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar',
    '/vcs/vscode-java-test/java-extension/com.microsoft.java.test.plugin.site/target/*.jar',
    '/vcs/vscode-java-test/java-extension/com.microsoft.java.test.plugin/target/*.jar',
    '/vcs/vscode-java-test/java-extension/com.microsoft.java.test.runner/target/*.jar',
    '/vcs/vscode-java-test/java-extension/com.microsoft.java.test.runner/lib/*.jar',
    '/vcs/vscode-java-test/server/*.jar'
  }

  local bundles = {}
  for _, jar_pattern in ipairs(jar_patterns) do
    for _, bundle in ipairs(vim.split(vim.fn.glob(home .. jar_pattern), '\n')) do
      if not vim.endswith(bundle, 'com.microsoft.java.test.runner.jar') then
        table.insert(bundles, bundle)
      end
    end
  end

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
    jdtls.setup_dap({hotcodereplace = 'auto'})
    -- needs to be after jdtls.setup_dap, so that debugging related cmds are included
    jdtls.setup.add_commands()
    mappings.set_jdtls_mappings(bufnr)
    dap.setup_dap_main_class_configs({verbose = true})
  end
end

local function get_config(base_config)
  return {
    -- One dedicated LSP server & client will be started per unique root_dir
    root_dir = jdtls.setup.find_root({'build.gradle'});
    cmd = get_cmd();
    settings = settings;
    flags = get_flags(base_config.flags);
    handlers = base_config.handlers;
    capabilities = base_config.capabilities;
    init_options = get_init_options();
    on_init = base_config.on_init;
    on_attach = java_on_attach(base_config.on_attach)
  }
end

function M.setup(base_config)
  local config = get_config(base_config)
  -- print(vim.inspect(config))
  jdtls.start_or_attach(coq.lsp_ensure_capabilities(config))
end


return M
