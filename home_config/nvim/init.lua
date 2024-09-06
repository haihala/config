-- Using fish is cool but for some reason doing it in vim makes everything very slow
vim.opt.shell = "/bin/bash"
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua"
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua"

require("remap")
require("set")
require("config.lazy")
