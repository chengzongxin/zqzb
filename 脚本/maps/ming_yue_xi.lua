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
    
    -- 点击冥月西教
    tap(706, 261)
    sleep(1000)
    
    -- 点击进入
    tap(456, 313)
    sleep(2000)
    
    return true
end

function MingYueXi:startFighting()
    print("开始在地图 " .. self.name .. " 打怪，持续 " .. (self.fightTime/1000/60) .. " 分钟")
    tap(1467, 415)  -- 自动战斗按钮
    sleep(1000)
    return true
end

function MingYueXi:fightInMap()
    -- 调用父类的fightInMap方法
    return Map.fightInMap(self)
end

function MingYueXi:leave()
    return true
end

return MingYueXi 