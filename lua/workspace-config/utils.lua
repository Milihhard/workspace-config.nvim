local file_exists = function(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

return {

  file_exists = file_exists,

  lines_from = function(file)
    if not file_exists(file) then return {} end
    local lines = ""
    for line in io.lines(file) do
      lines = lines .. line
    end
    return lines
  end
}
