local Path = require("plenary.path")

local data_path = vim.fn.stdpath("data")
local full_data_path = string.format("%s/workspaces.json", data_path)

---@param data any
local function write_data(data)
  Path:new(full_data_path):write(vim.json.encode(data), "w")
end

local M = {}

function M.__dangerously_clear_data()
  write_data({})
end

function M.info()
  return {
    data_path = data_path,
    full_data_path = full_data_path,
  }
end

local function has_keys(t)
  for _ in pairs(t) do
    return true
  end

  return false
end

--- @alias RawData string[]

--- @class Data
--- @field _data RawData
--- @field has_error boolean
local Data = {}

-- 1. load the data
-- 2. keep track of the lists requested
-- 3. sync save

Data.__index = Data

---@return RawData
local function read_data()
  local path = Path:new(full_data_path)
  local exists = path:exists()

  if not exists then
    write_data({})
  end

  local out_data = path:read()
  local data = vim.json.decode(out_data)
  return data
end

---@return Data
function Data:new()
  local ok, data = pcall(read_data)

  return setmetatable({
    _data = data,
    has_error = not ok,
  }, self)
end

---@param dir string
---@return string
function Data:_get_data(dir)
  if not self._data[dir] then
    self._data[dir] = ""
  end

  return self._data[dir] or ""
end

---@param dir string
---@return string
function Data:data(dir)
  if self.has_error then
    error(
      "Workspace config: there was an error reading the data file, cannot read data"
    )
  end

  return self:_get_data(dir)
end

---@param dir string
---@param value string
function Data:update(dir, value)
  if self.has_error then
    error(
      "Workspace config: there was an error reading the data file, cannot update"
    )
  end
  self:_get_data(dir)
  self._data[dir] = value
end

function Data:sync()
  print(vim.inspect(self._data))
  if self.has_error then
    return
  end

  local ok, data = pcall(read_data)
  if not ok then
    error("Workspace config: unable to sync data, error reading data file")
  end

  print(vim.inspect(self._data))
  for k, v in pairs(self._data) do
    data[k] = v
  end

  ok = pcall(write_data, data)

  if ok then
    self.seen = {}
  end
end

M.Data = Data

return M
