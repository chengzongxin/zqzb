local Map = require("map")
local DouLuo = require("specialmap/dou_luo")  -- 导入斗罗大世界模块
local MoveMode = require("move_mode")  -- 导入移动模式工具
local PathFinder = require("path_finder")  -- 导入寻路工具

local JiBei = {}
setmetatable(JiBei, {__index = Map})

function JiBei:new()
    local o = Map:new({
        name = "斗罗大世界-极北之地",
        fightTime = 3 * 60 * 1000,  -- 3分钟
        priority = 40
    })
    setmetatable(o, {__index = JiBei})
    return o
end

function JiBei:enter()
    print("开始进入极北之地...")
    
    -- 确保在跑步模式
    MoveMode:switchToRunning()
    
    -- 先进入斗罗大世界
    local douLuo = DouLuo:new()
    if not douLuo:enter() then
        print("进入斗罗大世界失败")
        return false
    end
    
    sleep(1000)
    
    -- 开始寻路到目标位置
    print("开始寻路到极北之地...")
    local targetX = 167  -- 目标X坐标
    local targetY = 56   -- 目标Y坐标
    
    -- 直接使用 PathFinder 的 moveToTarget 方法
    if not PathFinder:moveToTarget(targetX, targetY) then
        print("寻路失败")
        return false
    end
    
    print("已到达极北之地位置")
    
    -- 点击坐标(798, 420)
    print("点击极北之地入口...")
    tap(798, 420)
    sleep(1000)
    
    -- 等待并点击弹窗中的进入按钮
    print("等待弹窗出现...")
    local maxWaitTime = 5 * 1000  -- 最多等待5秒
    local startTime = os.time() * 1000
    
    while (os.time() * 1000 - startTime) < maxWaitTime do
        -- 查找并点击进入按钮
        local ret, x, y = findPic(0, 0, 0, 0, "进入.png", "101010", 0, 0.9)
        if ret ~= -1 then
            print("找到进入按钮，点击进入")
            tap(x, y)
            sleep(2000)  -- 等待进入动画
            return true
        end
        sleep(500)  -- 每500ms检查一次
    end
    
    print("未找到进入按钮，进入失败")
    return false
end

function JiBei:startFighting()
    return Map.startFighting(self)
end

function JiBei:fightInMap()
    return Map.fightInMap(self)
end

function JiBei:leave()
    return Map.leave(self)
end

return JiBei 