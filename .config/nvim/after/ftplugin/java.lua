local jdtls = require('jdtls')

local function get_cmd()
  local lombok_jar = XDG_DATA_HOME..'/lombok/lombok.jar'
  ---@diagnostic disable-next-line: missing-parameter
  local ls_jar = vim.fn.glob('/usr/share/java/jdtls/plugins/org.eclipse.equinox.launcher_*.jar')
  local config_dir = XDG_DATA_HOME..'/jdtls/config_linux'
  local project_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
  local project_data_dir = '/tmp/ws-'..project_dir

  local cmd = {
    'java',
    '-javaagent:'..lombok_jar,
    '-Xbootclasspath/a:'..lombok_jar,
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms512M',
    '-Xmx1G',
    '-jar', ls_jar,
    '-configuration', config_dir,
    '-data', project_data_dir,
    '--add-modules=ALL-SYSTEM',
    '--add-opens java.base/java.util=ALL-UNNAMED',
    '--add-opens java.base/java.lang=ALL-UNNAMED'
  }

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

local function get_bundles()
  local jar_patterns = {
    '/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar',
    '/vscode-java-test/java-extension/com.microsoft.java.test.plugin/target/*.jar',
    '/vscode-java-test/java-extension/com.microsoft.java.test.runner/target/*.jar',
    '/vscode-java-test/java-extension/com.microsoft.java.test.runner/lib/*.jar'
  }

  local bundles = {}
  for _, jar_pattern in ipairs(jar_patterns) do
    ---@diagnostic disable-next-line: missing-parameter
    for _, bundle in ipairs(vim.split(vim.fn.glob(os.getenv("VCS_DIR")..jar_pattern), '\n')) do
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

    require("mappings").jdtls(bufnr)
    require("jdtls.dap").setup_dap_main_class_configs({verbose = true})
    -- require('my.dap').setup()
  end
end

local function get_config()
  local base_config = require("my.lsp").get_config()
  return {
    root_dir = jdtls.setup.find_root({"gradlew"});
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

local config = get_config()
-- print(vim.inspect(config))
jdtls.start_or_attach(config)
