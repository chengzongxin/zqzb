-- 普通地图类
local Map = require("map")

local NormalMap = {}
setmetatable(NormalMap, {__index = Map})

-- 构造函数
function NormalMap:new(name, fightTime, priority, coordinates)
    local o = Map:new(name, "normal", fightTime, priority)
    o.coordinates = coordinates or {}
    setmetatable(o, {__index = NormalMap})
    return o
end

-- 进入地图
function NormalMap:enter()
    local canEnter, reason = self:canEnter()
    if not canEnter then
        print(self.name .. " 无法进入: " .. reason)
        return false
    end
    
    print("正在进入地图: " .. self.name)
    
    -- 点击大陆直飞
    tap(self.coordinates.flyButton.x, self.coordinates.flyButton.y)
    sleep(1000)
    
    -- 点击十六大陆
    tap(self.coordinates.sixteenContinent.x, self.coordinates.sixteenContinent.y)
    sleep(1000)
    
    -- 点击对应的打怪地点
    tap(self.coordinates.map.x, self.coordinates.map.y)
    sleep(1000)
    
    -- 对话框点击进入
    tap(self.coordinates.dialog.x, self.coordinates.dialog.y)
    sleep(2000)
    
    self.currentEntries = self.currentEntries + 1
    return true
end

-- 开始打怪
function NormalMap:startFighting()
    Map.startFighting(self)  -- 调用父类方法
    
    -- 开始自动战斗
    tap(1467, 415)  -- 自动战斗按钮
    sleep(1000)
    
    return true
end

return NormalMap 