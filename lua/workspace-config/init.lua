local M = {}
local config = require('workspace-config.config')
local utils = require('workspace-config.utils')
local data = require('workspace-config.data')
M._workspace_config = {}
M._config = {}
M._data = {}

M.setup = function(options)
  M._config = config.getConfig(options)
  M._data = data.Data:new()
  local workdir = vim.fn.getcwd()

  local config_workspace = workdir .. "/.nvim/config.json"
  if (utils.file_exists(config_workspace)) then
    local json = utils.lines_from(config_workspace)
    local workspaceConfig = vim.fn.json_decode(json)
    M._workspace_config = workspaceConfig
    M._config.onWorkspaceLoad(workspaceConfig)
  end
end
M.addWorkspace = function(worskpaceDir)
  M._data:update(worskpaceDir, worskpaceDir)
  data.Data:sync()
end
M.removeWorkspace = function(worskpaceDir)
  M._data:update(worskpaceDir, nil)
  data.Data:sync()
end
M.getConfig = function(key)
  return M._workspace_config[key]
end
-- M.setup({
--   onWorkspaceLoad = function(workspaceConfig)
--     print("Workspace loaded")
--     print(vim.inspect(workspaceConfig))
--   end,
-- })

return M
