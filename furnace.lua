--7
--item removal?
 
local version = 7
 
local latest = http.get("https://pastebin.com/raw/RQEuzDRi")
 
if latest ~= nil then
    local latestVersion = tonumber(string.sub(latest.readLine(), 3))
    if latestVersion > version then
        print("Out of date (version "..latestVersion.." is out).")
        print("Update notes: "..string.sub(latest.readLine(), 3))
        print("Updating.")
        fs.delete(shell.getRunningProgram())
        shell.run("wget https://pastebin.com/raw/RQEuzDRi furnace.lua")
        print("Update complete!")
        os.reboot()
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
