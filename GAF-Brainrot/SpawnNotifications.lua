--[ Wait for game to load ]
repeat task.wait() until game:IsLoaded()

if notifications_loaded then
    warn("[!] Grow and Feed Brainrot Notifications Already Loaded!")
    return
end
pcall(function() getgenv().notifications_loaded = true end)

--[ Services ]
local services = setmetatable({}, { __index = function(_, key) return game:GetService(key) end })
local client = services.Players.LocalPlayer

--[ Load webhook creator ]
local WH_Creator
do
    local source, httpError = game:HttpGet("https://raw.githubusercontent.com/LaDamage/Functions/refs/heads/main/wh_notifs.lua", true)
    if not source or source == "" then
        error("[!] Failed to fetch remote webhook creator: " .. tostring(httpError))
    end

    local chunk, loadError = loadstring(source)
    if not chunk then
        error("[!] Failed to compile webhook creator: " .. tostring(loadError))
    end

    local ok, result = pcall(chunk)
    if not ok then
        error("[!] Error running webhook creator chunk: " .. tostring(result))
    end

    if typeof(result) ~= "function" then
        error("[!] Webhook creator file did not return a function!")
    end

    WH_Creator = result
end

--[ Script ]
game:GetService("Workspace").Brainrots.ChildAdded:Connect(function(child)
    local ui = child:WaitForChild("UI")
    local billboard = ui:WaitForChild("BrainrotBillboard")

    local pet_name = billboard:WaitForChild("Label").Text
    local pet_rarity = billboard:WaitForChild("Rarity").Text
    local pet_tier = billboard:WaitForChild("Tier").Text

    if WantedPet == pet_name then
        local WebhookInfo = WH_Creator(pet_name, pet_tier, pet_rarity, DiscordID)
        request({
            Url = Webhook,
            Body = game:GetService("HttpService"):JSONEncode(WebhookInfo),
            Method = "POST",
            Headers = {["content-type"] = "application/json"}
        })
    end
end)

for _,v in getconnections(game:GetService("Players").LocalPlayer.Idled) do v:Disable() end
