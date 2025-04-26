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
    
    -- 点击冥月东教
    tap(611, 319)
    sleep(1000)
    
    -- 点击进入
    tap(456, 313)
    sleep(2000)
    
    return true
end

function MingYueDong:startFighting()
    print("开始在地图 " .. self.name .. " 打怪，持续 " .. (self.fightTime/1000/60) .. " 分钟")
    tap(1467, 415)  -- 自动战斗按钮
    sleep(1000)
    return true
end

function MingYueDong:fightInMap()
    -- 调用父类的fightInMap方法
    return Map.fightInMap(self)
end

function MingYueDong:leave()
    return true
end

return MingYueDong 