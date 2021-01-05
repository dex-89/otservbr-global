local config = { --Times are in seconds
    saveInterval = 1 * 60,
    minSaveInterval = 1 * 30,
    maxSaveInterval = 2 * 30,
    storage = Storage.SavePlayer,
}

local function doSavePlayerAndHouse(cid)
		Player(cid):save()
		doSaveHouse({getHouseByPlayerGUID(getPlayerGUID(cid))})
	return true
end

function saveRepeat(cid)
		if isPlayer(cid) then
			setPlayerStorageValue(cid, config.storage, addEvent(saveRepeat, config.saveInterval*1000, cid))
			doSavePlayerAndHouse(cid)
		end
	return true
end

local savePlayers = CreatureEvent("savePlayers")

function savePlayers.onLogin(cid)
	if savePlayer then
		setPlayerStorageValue(cid, config.storage, addEvent(saveRepeat,
									math.random(config.minSaveInterval, config.maxSaveInterval) * 1000, cid.uid))
	end
    return true
end

savePlayers:register()

local endSavePlayers = CreatureEvent("endSavePlayers")

function endSavePlayers.onLogout(cid)
	if savePlayer then
		doSaveHouse({getHouseByPlayerGUID(getPlayerGUID(cid))})
		stopEvent(getPlayerStorageValue(cid, config.storage))
	end
    return true
end

endSavePlayers:register()
