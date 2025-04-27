local Map = require("map")

local MingYueDong = {}
setmetatable(MingYueDong, {__index = Map})

function MingYueDong:new()
    local o = Map:new({
        name = "冥月东教",
        fightTime = 3 * 60 * 1000,  -- 3分钟
        priority = 40
    })
    setmetatable(o, {__index = MingYueDong})
    return o
end

function MingYueDong:enter()
    print("开始进入冥月东教...")
    -- 点击大陆直飞
    tap(1377, 322)
    sleep(1000)

    -- 点击十六大陆
    tap(732, 585)
    sleep(1000)
    
    -- 点击冥月东教
    tap(611, 319)
    sleep(1000)
    
    -- 点击进入
    tap(456, 313)
    sleep(2000)
    
    return true
end

function MingYueDong:startFighting()
    return Map.startFighting(self)
end

function MingYueDong:fightInMap()
    return Map.fightInMap(self)
end

function MingYueDong:leave()
    return Map.leave(self)
end

return MingYueDong 