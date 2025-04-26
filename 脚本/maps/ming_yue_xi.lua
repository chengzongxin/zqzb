local Map = require("map")

local MingYueXi = {}
setmetatable(MingYueXi, {__index = Map})

function MingYueXi:new()
    local o = Map:new({
        name = "明月溪",
        fightTime = 10 * 60 * 1000,  -- 10分钟
        priority = 70
    })
    setmetatable(o, {__index = MingYueXi})
    return o
end

function MingYueXi:enterFunction()
    print("开始进入明月溪...")
    
    -- 点击大陆直飞
    tap(1300, 54)
    sleep(1000)
    
    -- 点击十六大陆
    tap(672, 204)
    sleep(1000)
    
    -- 滑动屏幕
    swipe(1053, 731, 1056, 410, 200)
    sleep(800)
    swipe(1053, 731, 1056, 410, 200)
    sleep(800)
    swipe(1053, 731, 1056, 410, 200)
    sleep(800)
    
    -- 点击明月溪
    tap(1182, 570)
    sleep(1000)
    
    -- 点击进入
    tap(461, 305)
    sleep(2000)
    
    return true
end

function MingYueXi:startFighting()
    print("开始在地图 " .. self.name .. " 打怪，持续 " .. (self.fightTime/1000/60) .. " 分钟")
    tap(1467, 415)  -- 自动战斗按钮
    sleep(1000)
    return true
end

function MingYueXi:leave()
    return true
end

return MingYueXi 