  local getgenv, getnamecallmethod, hookmetamethod, newcclosure, checkcaller, stringlower = getgenv, getnamecallmethod, hookmetamethod, newcclosure, checkcaller, string.lower
if getgenv().ED_AntiKick then return end
local Players, StarterGui, OldNamecall = game:GetService("Players"), game:GetService("StarterGui")
getgenv().ED_AntiKick = {
	SendNotifications = false, 
	CheckCaller = false 
}
OldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
	if (getgenv().ED_AntiKick.CheckCaller and not checkcaller() or true) and stringlower(getnamecallmethod()) == "kick" then
		if getgenv().ED_AntiKick.SendNotifications then
			
		end

		return nil
	end

	return OldNamecall(...)
end))
