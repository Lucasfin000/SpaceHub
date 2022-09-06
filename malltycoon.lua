local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Space Hub | Mall Tycoon", HidePremium = false, SaveConfig = true, ConfigFolder = "Malltycoon"})
local main = Window:MakeTab({
	Name = "Money",
	Icon = "rbxassetid://4400700509",
	PremiumOnly = false
})
local money = Window:MakeTab({
	Name = "Credits",
	Icon = "rbxassetid://4483345737",
	PremiumOnly = false
})
OrionLib:MakeNotification({
	Name = "Space Hub",
	Content = "Space Hub Has Loaded!",
	Image = "rbxassetid://3610242099",
	Time = 5
})
main:AddButton({
	Name = "Auto Collect",
	Callback = function()
        while true do
local args = {
    [1] = "RequestCollectCash"
}

game:GetService("ReplicatedStorage").RemoteEvent:FireServer(unpack(args))
wait()
end

  	end  
})
money:AddButton({
	Name = "Scripter: Lucas!#5123",
	Callback = function()
        OrionLib:MakeNotification({
            Name = "Space Hub",
            Content = "Invite Link Copied!",
            Image = "rbxassetid://4483345278",
            Time = 5
        })
      setclipboard("https://discord.gg/lyc")
    end
})






OrionLib:Init()