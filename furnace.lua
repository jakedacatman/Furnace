--7
--item removal?
 
local version = 7
 
if not fs.exists("config.lua") then
    shell.run("wget https://raw.githubusercontent.com/jakedacatman/ChatLogger/master/config.lua config.lua")
end
 
local latest = http.get("https://raw.githubusercontent.com/jakedacatman/Furnace/master/furnace.lua")
 
if latest ~= nil then
    local latestVersion = tonumber(string.sub(latest.readLine(), 3))
    if latestVersion > version then
        print("Out of date (version "..latestVersion.." is out).")
        print("Update notes: "..string.sub(latest.readLine(), 3))
        print("Do you wish to update? (y/n)")
        local timeout = os.startTimer(15)
        while true do
            local event = {os.pullEvent()}
            if event[1] == "char" then
                if event[2] == "y" then
                    fs.delete(shell.getRunningProgram())
                    shell.run("wget https://raw.githubusercontent.com/jakedacatman/Furnace/master/furnace.lua sniffer.lua")
                    print("Update complete!")
                    print("If you wish to run the new version, then hold CTRL+T and run sniffer.lua.")
                else
                    print("Not updating.")
                    break
                end
            elseif event[1] == "timer" and event[2] == timeout then
                print("Not updating.")
                break
            end
        end
    else
        print("Up to date! (or Github hasn't pushed my update)")
    end
else
    print("Failed to check for new version.")
end
 
print("Running version "..version)
 
local chest = peripheral.find("minecraft:chest")
local furnaces = {}
 
local fuel = "minecraft:coal"
 
for i,v in pairs(chest.getTransferLocations()) do
    if v:sub(11, 17) == "furnace" then
        table.insert(furnaces, v)
        print("detected furnace "..v)
    end
end

function main()
 
end
 
function feeding()
    while true do
        for i = 1, 27 do
            while chest.getItemMeta(i) ~= nil do
                for k, v in pairs(furnaces) do
                    if chest.getItemMeta(i) then
                        if chest.getItemMeta(i).name == fuel then
                            chest.pushItems(v..".west_side", i, 1)
                        else
                            chest.pushItems(v..".up_side", i, 1)
                        end
                    end
                end
            end
        end
        sleep(10)
    end
end
 
function removal()
    while true do
        for i, v in pairs(furnaces) do
            local furnace = peripheral.wrap(v)
            local chestName = ""
            for k, w in pairs(furnace.getTransferLocations()) do
                if w:sub(11, 15) == "chest" then
                    chestName = w
                end
            end
            if furnace.getItemMeta(3) then -- slot 3 is output
                furnace.pushItems(chestName, 3)
            end
        end
        sleep(3)
    end
end
 
parallel.waitForAny(feeding, removal)
