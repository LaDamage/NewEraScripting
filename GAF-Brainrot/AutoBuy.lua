local player = game:GetService("Players").LocalPlayer
local SeedList = player.PlayerGui.Menus.Seeds.Frame.List
local RelicList = player.PlayerGui.Menus.Relics.Frame.List

local RS = game:GetService("ReplicatedStorage")
local Remotes = RS.Paper.Remotes.__remotefunction
local Event = game:GetService("ReplicatedStorage").Paper.Remotes.chatmessage

local function SendChatMessage(tag_color, tag, msg)
    firesignal(Event.OnClientEvent, "<font color='"..tag_color.."'>["..tag.."]</font> ".. msg)
end

SendChatMessage("#1e90ff", "TIP", "GAF AutoBuy is ".. tostring(AutoBuy))
while AutoBuy and task.wait(Buy_interval) do
    if Seed_To_Buy ~= "" then
        if SeedList[Seed_To_Buy].Main.Stock.Text ~= "Out of stock!" then
            Remotes:InvokeServer("Buy Seed", Seed_To_Buy)
        	SendChatMessage("#1e90ff", "Seeds", "Bought a ".. Seed_To_Buy.." Seed!")
        end
    end
    if Relic_To_Buy ~= "" then
        if RelicList[Relic_To_Buy].Main.Stock.Text ~= "Out of stock!" then
            Remotes:InvokeServer("Buy Relic", Relic_To_Buy)
			SendChatMessage("#1e90ff", "Relics", "Bought a ".. Relic_To_Buy.." Relic!")
        end
	end
end

for _,v in getconnections(game:GetService("Players").LocalPlayer.Idled) do v:Disable() end
