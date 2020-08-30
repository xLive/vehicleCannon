addEventHandler("onClientResourceStart", resourceRoot,
    function()
        triggerServerEvent(resource.name .. ":getSettings", resourceRoot)
    end
)

function onDamage(_, damage)
    if damage >= 22 and damage <= 34 then
        cancelEvent()
    end
end

function onSettingsChange(setting, value)
    if type(setting) == "table" then
        for setting, value in pairs(setting) do
            updateSetting(setting, value)
        end
    else
        updateSetting(setting, value)
    end
end
addEvent(resource.name .. ":setSettings", true)
addEvent(resource.name .. ":setSetting", true)
addEventHandler(resource.name .. ":setSettings", resourceRoot, onSettingsChange)
addEventHandler(resource.name .. ":setSetting", resourceRoot, onSettingsChange)

function updateSetting(setting, value)
    if setting == "canceldamage" then
        if value == "true" then
            addEventHandler("onClientPlayerDamage", root, onDamage)
        else
            removeEventHandler("onClientPlayerDamage", root, onDamage)
        end
    end
end
