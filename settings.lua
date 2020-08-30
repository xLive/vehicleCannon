settings = {
    weapon = get("weapon"):lower() == "all" and "all" or split(get("weapon"), ",") or "all",
    maxVehicles = math.max(tonumber(get("maxvehicles")) or 25, 1),
    destoryAfter = math.max(tonumber(get("destoryafter")) * 1000 or 50000, 50),
    vehicleSpeed = tonumber(get("vehiclespeed")) or 4,
    lockVehicle = get("lockvehicle"):lower() == "true",
    vehicleIds = not (get("vehicleids"):lower() == "all") and split(get("vehicleids"), ",") or
    {602,545,496,517,401,410,518,600,527,436,589,580,419,439,
    549,526,491,474,445,604,507,585,587,466,492,546,551,516,467,426,547,405,
    550,566,540,421,529,581,509,481,462,521,463,510,522,461,448,468,586,485,
    552,431,438,437,574,420,525,408,416,433,427,490,528,407,544,523,470,598,
    596,597,599,601,428,499,609,498,524,532,578,486,406,573,455,588,403,514,
    423,414,443,515,531,456,459,422,482,605,530,418,572,582,413,440,543,583,
    478,554,536,575,534,567,535,576,412,402,542,603,475,568,424,504,457,483,
    508,571,500,444,556,557,471,495,429,541,415,480,562,323,492,502,503,411,
    559,561,560,506,451,558,555,477,579,400,404,489,505,409,479,533,442,458},
    cancelDamage = tostring(get("canceldamage"):lower() == "true")
}

local clientSettings = {
    ["canceldamage"] = "cancelDamage"
}

function onSettingChange(setting, _, new)
    local setting = setting:sub(#("*" .. resource.name .. ".") + 1, #setting)
    local value = fromJSON(new)
    if setting == "weapon" then
        settings.weapon = get("weapon") == "all" and "all" or split(get("weapon"), ",")
    elseif setting == "maxvehicles" then
        settings.maxVehicles = tonumber(value) or 15
    elseif setting == "destoryafter" then
        settings.destoryAfter = math.max(tonumber(get("destoryafter")) * 1000 or 50000, 50)
    elseif setting == "vehiclespeed" then
        settings.vehicleSpeed = tonumber(get("vehiclespeed")) or 4
    elseif setting == "lockvehicle" then
        settings.lockVehicle = value:lower() == "true"
    elseif setting == "vehicleids" then
        settings.vehicleIds =
            not (value:lower() == "all") and split(value, ",") or
            {602,545,496,517,401,410,518,600,527,436,589,580,419,439,
            549,526,491,474,445,604,507,585,587,466,492,546,551,516,467,426,547,405,
            550,566,540,421,529,581,509,481,462,521,463,510,522,461,448,468,586,485,
            552,431,438,437,574,420,525,408,416,433,427,490,528,407,544,523,470,598,
            596,597,599,601,428,499,609,498,524,532,578,486,406,573,455,588,403,514,
            423,414,443,515,531,456,459,422,482,605,530,418,572,582,413,440,543,583,
            478,554,536,575,534,567,535,576,412,402,542,603,475,568,424,504,457,483,
            508,571,500,444,556,557,471,495,429,541,415,480,562,323,492,502,503,411,
            559,561,560,506,451,558,555,477,579,400,404,489,505,409,479,533,442,458}
    elseif clientSettings[setting] then
        if setting == "canceldamage" then
            settings.cancelDamage = tostring(value:lower() == "true")
        end
        triggerClientEvent(resource.name .. ":setSetting", resourceRoot, setting, value)
    end
end
addEventHandler("onSettingChange", resourceRoot, onSettingChange)

addEvent(resource.name .. ":getSettings", true)
addEventHandler(resource.name .. ":getSettings", resourceRoot,
    function()
        local settingsTable = {}
        for setting, key in pairs(clientSettings) do
            settingsTable[setting] = settings[key]
        end
        triggerClientEvent(client, resource.name .. ":setSettings", resourceRoot, settingsTable)
    end
)
