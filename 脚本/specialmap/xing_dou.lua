local Map = require("map")
local DouLuo = require("specialmap/dou_luo")  -- 导入斗罗大世界模块

local XingDou = {}
setmetatable(XingDou, {__index = Map})

function XingDou:new()
    local o = Map:new({
        name = "斗罗大世界-星斗大森林",
        fightTime = 3 * 60 * 1000,  -- 3分钟
        priority = 40
    })
    setmetatable(o, {__index = XingDou})
    return o
end

function XingDou:enter()
    print("开始进入星斗大森林...")
    
    -- 先进入斗罗大世界
    local douLuo = DouLuo:new()
    if not douLuo:enter() then
        print("进入斗罗大世界失败")
        return false
    end
    
    sleep(1000)
    -- 寻找并点击星斗大森林
    local ret, x, y = findPic(0,0,0,0,"星斗大森林.png","101010",0,0.75)
    if ret ~= -1 then
        print("找到星斗大森林入口")
        tap(x, y)
        sleep(1000)
        
        -- 点击进入
        tap(707, 262)
        sleep(2000)
        return true
    else
        print("未找到星斗大森林入口")
        return false
    end
end

function XingDou:startFighting()
    return Map.startFighting(self)
end

function XingDou:fightInMap()
    return Map.fightInMap(self)
end

function XingDou:leave()
    return Map.leave(self)
end

return XingDou 