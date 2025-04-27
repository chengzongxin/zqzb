local Map = require("map")

local MingYueXi = {}
setmetatable(MingYueXi, {__index = Map})

function MingYueXi:new()
    local o = Map:new({
        name = "冥月西教",
        fightTime = 3 * 60 * 1000,  -- 3分钟
        priority = 30
    })
    setmetatable(o, {__index = MingYueXi})
    return o
end

function MingYueXi:enter()
    print("开始进入冥月西教...")
    -- 点击大陆直飞
    tap(1377, 322)
    sleep(1000)

    -- 点击十六大陆
    tap(732, 585)
    sleep(1000)
    
    -- 点击冥月西教
    tap(706, 261)
    sleep(1000)
    
    -- 点击进入
    tap(456, 313)
    sleep(2000)
    
    return true
end

function MingYueXi:startFighting()
    return Map.startFighting(self)
end

function MingYueXi:fightInMap()
    return Map.fightInMap(self)
end

function MingYueXi:leave()
    return Map.leave(self)
end

return MingYueXi 