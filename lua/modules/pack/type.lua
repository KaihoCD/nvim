-- [[ Plugin Specification Types ]]

---@class modules.pack.PluginUserSpec
---@field src string
---@field name? string
---@field event? string|string[]
---@field ft? string|string[]
---@field version? string
---@field opts? table
---@field config? fun(opts?: table)
---@field deps? modules.pack.PluginUserSpec[]

---@class modules.pack.PluginSpec
---@field src string
---@field name string
---@field version? string
---@field event? string[]
---@field ft? string[]
---@field opts table
---@field config? fun(opts?: table)
---@field deps string[]
---@field loaded boolean

---@alias modules.pack.PluginSpecMap table<string, modules.pack.PluginSpec>
---@alias modules.pack.PluginSpecEntryList string[]

-- [[ Queue Builder Types ]]

---@class modules.pack.PackQueue
---@field startup string[]
---@field event table<string, string[]>
---@field ft table<string, string[]>

---@alias modules.pack.DepGraph table<string, string[]>
---@alias modules.pack.SeenSet table<string, boolean>

-- [[ Pack Manager Types ]]

---@class modules.pack.PackManager
---@field use fun(name: string)
