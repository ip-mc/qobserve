Service = require("qobserve/service")
Comp = {}

function Comp:New(o)
    print("COMP: new")
    local o = o or {}
    setmetatable(o, self)
    self.__index = self
    o:Initialize()
    return o
end

function Comp:Initialize()
    -- needed so that self can be reffered to in Handler
    print("COMP: initialize")
    self.Handler = function(ctrl)
        -- handles data changes in control
        print("COMP: handler")
        Service:SendLog(self, ctrl) -- offload handler to service interface
    end
end

function Comp:GetControls()
    print("COMP: get controls "..self.name)
    self.compObj = Component.New(self.name)
    local ctrls = {} -- table to hold control names and control objects

    for k,v in pairs(self.compObj) do -- iterate through all controls of component
        for a,b in pairs(self.ctrls) do -- iterate over controls defined in configuration file
            if string.find(string.upper(b), string.upper(k)) then 
                ctrls[k] = v -- store defined controls in ctrls
            end
        end
    end
    self.ctrls = ctrls -- store defined controls in object
    for c,d in pairs(self.ctrls) do
        d.EventHandler = self.Handler -- set all defined controls event handler to Handler
    end
end

return Comp