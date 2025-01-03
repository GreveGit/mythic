local _r = false

AddEventHandler("Pwnzor:Shared:DependencyUpdate", RetrieveComponents)
function RetrieveComponents()
	Callbacks = exports["mancave-core"]:FetchComponent("Callbacks")
	Notification = exports["mancave-core"]:FetchComponent("Notification")
	Weapons = exports["mancave-core"]:FetchComponent("Weapons")
end

AddEventHandler("Core:Shared:Ready", function()
	exports["mancave-core"]:RequestDependencies("Pwnzor", {
		"Callbacks",
		"Notification",
		"Weapons",
	}, function(error)
		if #error > 0 then
			return
		end
		RetrieveComponents()
		if not _r then
			_r = true
			RegisterEvents()
			RegisterCommands()

			-- Callbacks:ServerCallback("Commands:ValidateAdmin", {}, function(isAdmin)
			-- 	if not isAdmin then
			-- 		CreateThread(function()
			-- 			while _r do
			-- 				Wait(1)
			-- 				local ped = PlayerPedId()
			-- 				SetPedInfiniteAmmoClip(ped, false)
			-- 				SetEntityInvincible(ped, false)
			-- 				SetEntityCanBeDamaged(ped, true)
			-- 				ResetEntityAlpha(ped)
			-- 				local fallin = IsPedFalling(ped)
			-- 				local ragg = IsPedRagdoll(ped)
			-- 				local parac = GetPedParachuteState(ped)
			-- 				if parac >= 0 or ragg or fallin then
			-- 					SetEntityMaxSpeed(ped, 80.0)
			-- 				else
			-- 					SetEntityMaxSpeed(ped, 7.1)
			-- 				end
			-- 			end
			-- 		end)
			-- 	end
			-- end)
		end
	end)
end)

AddEventHandler("onResourceStart", function(resourceName)
	if GetGameTimer() >= 10000 then
		TriggerServerEvent("Pwnzor:Server:ResourceStarted", resourceName)
	end
end)

AddEventHandler("onResourceStopped", function(resourceName)
	TriggerServerEvent("Pwnzor:Server:ResourceStopped", resourceName)
end)
