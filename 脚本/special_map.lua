-- 特殊地图类
local Map = require("map")

local SpecialMap = {}
setmetatable(SpecialMap, {__index = Map})

-- 构造函数
function SpecialMap:new(name, fightTime, priority, enterSteps)
    local o = Map:new(name, "special", fightTime, priority)
    o.enterSteps = enterSteps or {}
    setmetatable(o, {__index = SpecialMap})
    return o
end

-- 开始打怪
function SpecialMap:startFighting()
    Map.startFighting(self)  -- 调用父类方法
    
    -- 开始自动战斗
    tap(1467, 415)  -- 自动战斗按钮
    sleep(1000)
    
    return true
end

return SpecialMap 