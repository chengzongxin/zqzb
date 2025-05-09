local Map = require("map")

local FengDu = {}
setmetatable(FengDu, {__index = Map})

function FengDu:new()
    local o = Map:new({
        name = "酆都鬼蜮",
        fightTime = 10 * 60 * 1000,  -- 10分钟
        priority = 80,
        timeRestricted = true,
        validTimeRange = {18, 24, 0, 6}  -- 18:00-24:00 和 00:00-06:00
    })
    setmetatable(o, {__index = FengDu})
    return o
end

function FengDu:enter()
    print("开始进入酆都鬼蜮...")
    
    -- 点击变强攻略
    tap(1300, 54)
    sleep(1000)
    
    -- 点击推荐打宝
    tap(672, 204)
    sleep(1000)
    
    -- 滑动屏幕
    swipe(1053, 731, 1056, 410, 200)
    sleep(800)
    swipe(1053, 731, 1056, 410, 200)
    sleep(800)
    
    -- 点击酆都鬼蜮
    tap(1202, 418)
    sleep(1000)
    
    -- 点击进入
    tap(482, 597)
    sleep(2000)
    
    return true
end

function FengDu:startFighting()
    return Map.startFighting(self)
end

function FengDu:fightInMap()
    return Map.fightInMap(self)
end

function FengDu:leave()
    return Map.leave(self)
end

return FengDu 