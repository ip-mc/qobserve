Conf = require("qobserve/conf")
Comp = require("qobserve/comp")

Main = {}

function Main:Run()
    print("Main: run")
    Main.Conf = Conf:New()
    Main.Comps = {} -- table to store component objects
    Main.Conf:GetConfig() -- get configuration data
    Main.CompData = Main.Conf:ParseConfig() -- get component data from config
    for _, c in pairs(Main.CompData) do
        local comp = Comp:New(c) -- create component object with configuration data
        table.insert(Main.Comps, comp)
    end
    for _, c in pairs(Main.Comps) do
        c:GetControls()
    end
end

return Main