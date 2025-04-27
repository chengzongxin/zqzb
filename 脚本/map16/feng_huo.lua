local Map = require("map")

local FengHuo = {}
setmetatable(FengHuo, {__index = Map})

function FengHuo:new()
    local o = Map:new({
        name = "风火门",
        fightTime = 3 * 60 * 1000,  -- 3分钟
        priority = 50
    })
    setmetatable(o, {__index = FengHuo})
    return o
end

function FengHuo:enter()
    print("开始进入风火门...")
    -- 点击大陆直飞
    tap(1377, 322)
    sleep(1000)

    -- 点击十六大陆
    tap(732, 585)
    sleep(1000)
    
    -- 点击风火门
    tap(521, 392)
    sleep(1000)
    
    -- 点击进入
    tap(456, 313)
    sleep(1000)
    
    return true
end

function FengHuo:startFighting()
    return Map.startFighting(self)
end

function FengHuo:fightInMap()
    return Map.fightInMap(self)
end

function FengHuo:leave()
    return Map.leave(self)
end

return FengHuo 