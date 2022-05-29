local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/wally-rblx/uwuware-ui/main/main.lua"))()

local framework, scrollHandler
while true do
    for _, obj in next, getgc(true) do
        if type(obj) == 'table' and rawget(obj, 'GameUI') then
            framework = obj;
            break
        end 
    end

    for _, module in next, getloadedmodules() do
        if module.Name == 'ScrollHandler' then
            scrollHandler = module;
            break;
        end
    end

    if (type(framework) == 'table') and (typeof(scrollHandler) == 'Instance') then
        break
    end

    wait(1)
end

local runService = game:GetService('RunService')
local userInputService = game:GetService('UserInputService')
local client = game:GetService('Players').LocalPlayer;
local random = Random.new()

local fastWait, fastSpawn, fireSignal, rollChance do
    -- https://eryn.io/gist/3db84579866c099cdd5bb2ff37947cec
    -- bla bla spawn and wait are bad 
    -- can also use bindables for the fastspawn idc

    function fastWait(t)
        local d = 0;
        while d < t do
            d += runService.RenderStepped:wait()
        end
    end

    function fastSpawn(f)
        coroutine.wrap(f)()
    end
    
    -- updated for script-ware or whatever
    -- attempted to update for krnl 
    local set_identity = (type(syn) == 'table' and syn.set_thread_identity) or setidentity or setthreadcontext
    function fireSignal(target, signal, ...)
        -- getconnections with InputBegan / InputEnded does not work without setting Synapse to the game's context level
        set_identity(2) 
        for _, signal in next, getconnections(signal) do
            if type(signal.Function) == 'function' and islclosure(signal.Function) then
                local scr = rawget(getfenv(signal.Function), 'script')
                if scr == target then
                    pcall(signal.Function, ...)
                end
            end
        end
        set_identity(7)
    end

    -- uses a weighted random system
    -- its a bit scuffed rn but it works good enough

    function rollChance()
        local chances = {
            { type = 'Sick', value = library.flags.sickChance },
            { type = 'Good', value = library.flags.goodChance },
            { type = 'Ok', value = library.flags.okChance },
            { type = 'Bad', value = library.flags.badChance },
        }
        
        table.sort(chances, function(a, b) 
            return a.value > b.value 
        end)

        local sum = 0;
        for i = 1, #chances do
            sum += chances[i].value
        end

        if sum == 0 then
            -- forgot to change this before?
            -- fixed 6/5/21
            return chances[random:NextInteger(1, 4)].type 
        end

        local initialWeight = random:NextInteger(0, sum)
        local weight = 0;

        for i = 1, #chances do
            weight = weight + chances[i].value

            if weight > initialWeight then
                return chances[i].type
            end
        end

        return 'Sick' -- just incase it fails?
    end
end

local map = { [0] = 'Left', [1] = 'Down', [2] = 'Up', [3] = 'Right', }
local keys = { Up = Enum.KeyCode.Up; Down = Enum.KeyCode.Down; Left = Enum.KeyCode.Left; Right = Enum.KeyCode.Right; }

-- they are "weird" because they are in the middle of their Upper & Lower ranges 
-- should hopefully make them more precise!
local chanceValues = {
    Sick = 96,
    Good = 92,
    Ok = 87,
    Bad = 77,
}

local marked = {}
local hitChances = {}

if shared._id then
    pcall(runService.UnbindFromRenderStep, runService, shared._id)
end

shared._id = game:GetService('HttpService'):GenerateGUID(false)
runService:BindToRenderStep(shared._id, 1, function()
    if (not library.flags.autoPlayer) then return end

    for i, arrow in next, framework.UI.ActiveSections do
        if (arrow.Side == framework.UI.CurrentSide) and (not marked[arrow]) then 
            local indice = (arrow.Data.Position % 4) -- mod 4 because 5%4 -> 0, 6%4 = 1, etc
            local position = map[indice]
            
            if (position) then
                local currentTime = framework.SongPlayer.CurrentlyPlaying.TimePosition
                local distance = (1 - math.abs(arrow.Data.Time - currentTime)) * 100

                if (arrow.Data.Time == 0) then
                --  print('invisible', tableToString(arrow.Data), i, distance)
                    continue
                end

                local hitChance = hitChances[arrow] or rollChance()
                hitChances[arrow] = hitChance

                -- if (not chanceValues[hitChance]) then warn('invalid chance', hitChance) end
                if distance >= chanceValues[hitChance] then
                    marked[arrow] = true;
                    fireSignal(scrollHandler, userInputService.InputBegan, { KeyCode = keys[position], UserInputType = Enum.UserInputType.Keyboard }, false)

                    -- wait depending on the arrows length so the animation can play
                    if arrow.Data.Length > 0 then
                        fastWait(arrow.Data.Length)
                    else
                        fastWait(0.075) -- 0.1 seems to make it miss more, this should be fine enough?
                    end

                    fireSignal(scrollHandler, userInputService.InputEnded, { KeyCode = keys[position], UserInputType = Enum.UserInputType.Keyboard }, false)
                    marked[arrow] = false;
                end
            end
        end
    end
end)

local window = library:CreateWindow('Funky Friday') do
    local folder = window:AddFolder('Main') do
        folder:AddToggle({ text = 'Autoplayer', flag = 'autoPlayer' })

        folder:AddSlider({ text = 'Sick %', flag = 'sickChance', min = 0, max = 100, value = 100 })
        folder:AddSlider({ text = 'Good %', flag = 'goodChance', min = 0, max = 100, value = 0 })
        folder:AddSlider({ text = 'Ok %', flag = 'okChance', min = 0, max = 100, value = 0 })
        folder:AddSlider({ text = 'Bad %', flag = 'badChance', min = 0, max = 100, value = 0 })
    end

    local folder = window:AddFolder('Credits') do
        folder:AddLabel({ text = 'Credits' })
        folder:AddLabel({ text = 'Lucas#5123' })
        folder:AddLabel({ text = 'discord.gg/lyc' })
    end
end


library:Init()