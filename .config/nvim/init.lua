local NVIM_CONFIG_HOME = os.getenv('XDG_CONFIG_HOME') .. '/nvim'
package.path = package.path .. ';' .. NVIM_CONFIG_HOME .. '/?.lua;' .. NVIM_CONFIG_HOME .. '/my/?.lua'

require('lua.my.plugins')
require('lua.my.plugins-config')
require('lua.my.functions')
require('lua.my.commands')
require('lua.my.autocmds')
require('lua.my.mappings')
require('lua.my.settings')

require('lua.my.ls')
require('lua.my.dap')
