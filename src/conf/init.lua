json = require("json")

Conf = {}

function Conf:New(o)
    print("CONF: new")
    local o = o or {}
    setmetatable(o, self)
    self.__index = self
    o.ConfigFile = "design/lua/qobserve/config.json"
    return o
end

function Conf:GetConfig()
    -- open config file and return lua table with it's contents
    print("CONF: get config")
    local file = io.open(self.ConfigFile, "r")
    local content = file:read("*a")
    file:close()
    self.Config = json.decode(content)
end

function Conf:ParseConfig()
    -- parse the config to get configuration data for components
    -- returns table of component tables with configuration data
    print("CONF: parse config")
    local compObjs = {} 
    local compNames = {}
    for k,v in pairs(self.Config.events.components) do
        -- get component names
        if v.componentNames[1] == "all" then
            -- use all components in the design
            local comps = Component.GetComponents()
            for i, component in pairs(comps) do
                table.insert(compNames, component.Name)
            end
        else
            compNames = v.componentNames
    end
        for _, comp in pairs(compNames) do
          -- create table with configuration data and component name
            local c = {
                service = self.Config.service,
                name = comp,
                ctrls = v.controlNames,
                action = "event",
                method = "log"
            }
            table.insert(compObjs, c)
        end
    end
    return compObjs
  end

return Conf