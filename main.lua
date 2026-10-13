-- main.lua
-- Loader: tries to run an obfuscated local file (K.obf.lua). If not present, downloads the original K from raw.githubusercontent and runs it.

local function try_load_local(fname)
  -- Works in plain Lua (io) and in LÖVE (love.filesystem)
  local content
  if type(love) == "table" and love.filesystem and love.filesystem.read then
    local ok
    ok, content = pcall(love.filesystem.read, fname)
    if not ok then content = nil end
  else
    local f = io.open(fname, "r")
    if f then
      content = f:read("*a")
      f:close()
    end
  end
  if not content then return false end
  local chunk = (loadstring and loadstring(content)) or load(content)
  if not chunk then return false end
  chunk()
  return true
end

if try_load_local("K.obf.lua") then return end

-- Fallback: download raw source and run it (requires LuaSocket)
local url = "https://raw.githubusercontent.com/MAMZHOE/Alluneedislove/main/K"
local ok, body, code = pcall(function()
  local http = require("socket.http")
  return http.request(url)
end)
if not ok or not body then
  error("Failed to load K.obf.lua and failed to download original source. Install LuaSocket or place K.obf.lua next to this file.")
end
local chunk = (loadstring and loadstring(body)) or load(body)
assert(chunk, "compile failed")
chunk()
