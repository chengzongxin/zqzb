local Map = require("map")

local HeiMo = {}
setmetatable(HeiMo, {__index = Map})

function HeiMo:new()
    local o = Map:new({
        name = "黑魔门",
        fightTime = 3 * 60 * 1000,  -- 3分钟
        priority = 60
    })
    setmetatable(o, {__index = HeiMo})
    return o
end

function HeiMo:enter()
    print("开始进入黑魔门...")
    -- 点击大陆直飞
    tap(1377, 322)
    sleep(1000)

    -- 点击十六大陆
    tap(732, 585)
    sleep(1000)
    
    -- 点击黑魔门
    tap(415, 445)
    sleep(1000)
    
    -- 点击进入
    tap(456, 313)
    sleep(2000)
    
    return true
end

function HeiMo:startFighting()
    print("开始在地图 " .. self.name .. " 打怪，持续 " .. (self.fightTime/1000/60) .. " 分钟")
    tap(1467, 415)  -- 自动战斗按钮
    sleep(1000)
    return true
end

function HeiMo:fightInMap()
    -- 调用父类的fightInMap方法
    return Map.fightInMap(self)
end

function HeiMo:leave()
    return true
end

return HeiMo 