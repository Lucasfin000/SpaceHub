-- Function to create a box around a player's head
local function createHeadBox(player)
    local character = player.Character
    if character then
        local head = character:FindFirstChild("Head")
        if head then
            local headBox = Instance.new("BillboardGui")
            headBox.Name = "HeadBox"
            headBox.Adornee = head
            headBox.Size = UDim2.new(2, 0, 2, 0) -- Adjust the size as needed
            headBox.StudsOffset = Vector3.new(0, 2, 0) -- Adjust the position

            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 1, 0)
            frame.BackgroundColor3 = Color3.new(1, 0, 0) -- Red color (you can change this)
            frame.BorderSizePixel = 0
            frame.Parent = headBox

            headBox.Parent = player:FindFirstChild("PlayerGui")
        end
    end
end

-- Function to remove the head box
local function removeHeadBox(player)
    local playerGui = player:FindFirstChild("PlayerGui")
    if playerGui then
        local headBox = playerGui:FindFirstChild("HeadBox")
        if headBox then
            headBox:Destroy()
        end
    end
end

-- Call the functions for player adding and player removing
game.Players.PlayerAdded:Connect(function(player)
    createHeadBox(player)
end)

game.Players.PlayerRemoving:Connect(function(player)
    removeHeadBox(player)
end)

-- You can also call createHeadBox for existing players in the game
for _, player in pairs(game.Players:GetPlayers()) do
    createHeadBox(player)
end
