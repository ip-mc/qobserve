Secrets = require("qobserve/secrets")
Splunk = {}

function Splunk:Handler(tbl, code, data, err)
    -- handles data returned from splunk
    print("SPLUNK: Response")
    print(tbl, code, data, err)
end

function Splunk:FormatEvent(data, secrets)
   -- format event data for splunk
    print("SPLUNK: Format Event")
    local index = Secrets:Decrypt(secrets.splunkIndex) -- decrypt splunk index from secrets file
    local source = data["source"] -- component that the event is coming from
    local hostname = data["hostname"] -- hostname of the core
    data["source"] = nil -- delete so that the data doesn't show up twice in the log
    data["hostname"] = nil -- delete so that the data doesn't show up twice in the log
    local log = {
        index = index, -- splunk index
        host = hostname, -- core hostname
        sourcetype = "qsys-event",
        source = source, -- component that the event is coming from
        event = data -- event data
    }
    return log
end

function Splunk:SendLog(data, secrets)
    print("SPLUNK: sending log")
    -- send log to splunk
    local token = Secrets:Decrypt(secrets.splunkToken)
    local HECServer = Secrets:Decrypt(secrets.splunkURL)
    local headers = {
        Authorization = "Splunk "..token
    }
     HttpClient.Post(
         {
           Url = HECServer,
           Headers = headers,
           Data = json.encode(data),
           EventHandler = Splunk.Handler
         }
       )
end


return Splunk