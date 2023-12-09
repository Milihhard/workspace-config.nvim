return {
  getConfig = function(userConfig)
    if (userConfig == nil) then
      userConfig = {}
    end
    local onWorkspaceLoad = function(workspaceConfig)
    end
    if (userConfig.onWorkspaceLoad ~= nil) then
      onWorkspaceLoad = userConfig.onWorkspaceLoad
    end

    return {
      onWorkspaceLoad = onWorkspaceLoad
    }
  end
}
