
while _G.Toggle do wait()
    for i,v in pairs(game:GetService("Workspace")["__THINGS"].Lootbags:GetChildren()) do
    v.CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position)
    end
end
