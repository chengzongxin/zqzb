local Map = require("map")

local QingLan = {}
setmetatable(QingLan, {__index = Map})

function QingLan:new()
    local o = Map:new({
        name = "青兰圣地",
        fightTime = 3 * 60 * 1000,  -- 3分钟
        priority = 40
    })
    setmetatable(o, {__index = QingLan})
    return o
end

function QingLan:enter()
    print("开始进入青兰圣地...")
    -- 点击大陆直飞
    tap(1377, 322)
    sleep(1000)

    -- 点击十六大陆
    tap(732, 585)
    sleep(1000)
    
    -- 点击青兰圣地
    tap(849, 265)
    sleep(1000)
    
    -- 点击进入
    tap(456, 313)
    sleep(2000)
    
    return true
end

function QingLan:startFighting()
    return Map.startFighting(self)
end

function QingLan:fightInMap()
    return Map.fightInMap(self)
end

function QingLan:leave()
    return Map.leave(self)
end

return QingLan 