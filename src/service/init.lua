Secrets = require("qobserve/secrets")
Splunk = require("qobserve/splunk")

Service = {}

function Service:SendLog(compObj, ctrl)
    print("SERVICE: send log")
    local secrets = Secrets:GetSecrets() -- get secrets from secrets file
    local hostname = "n/a"
    for k,v in pairs(Design.GetInventory()) do
        -- get hostname of core
        if v.Type == "Processor" then
            hostname = v.Name
        end
    end
    local ctrlName = ""
    for k,v in pairs(compObj.ctrls) do
        -- get control name
        if v == ctrl then
          ctrlName = k
        end
    end
    local data = { -- package log data
        hostname = hostname, -- hostname of core
        source = compObj.name, -- component that the event is coming from
        control = ctrlName, -- control that changed
        ["type"] = ctrl.Type, -- control type
        value = ctrl.Value, -- control value
        boolean = tostring(ctrl.Boolean), -- control boolean value
        message = ctrl.String -- control string value
    }
    if compObj.service == "splunk" then
        print("SERVICE: splunk")
        local log = Splunk:FormatEvent(data, secrets) -- format log data for splunk
        Splunk:SendLog(log, secrets) -- send log data to splunk
    end
end

return Service