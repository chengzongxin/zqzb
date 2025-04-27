local Map = require("map")

local DouLuo = {}
setmetatable(DouLuo, {__index = Map})

function DouLuo:new()
    local o = Map:new({
        name = "斗罗大世界",
        fightTime = 10 * 60 * 1000,  -- 10分钟
        priority = 70
    })
    setmetatable(o, {__index = DouLuo})
    return o
end

function DouLuo:enter()
    print("开始进入斗罗大世界...")
    
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
    
    -- 点击斗罗大世界
    tap(1182, 570)
    sleep(1000)
    
    -- 点击进入
    tap(461, 305)
    sleep(2000)
    
    return true
end

function DouLuo:startFighting()
    return Map.startFighting(self)
end

function DouLuo:fightInMap()
    return Map.fightInMap(self)
end

function DouLuo:leave()
    return Map.leave(self)
end

return DouLuo 