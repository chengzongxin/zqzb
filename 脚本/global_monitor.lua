-- 全局监控类
local Config = require("config")

local GlobalMonitor = {}

-- 构造函数
function GlobalMonitor:new()
    local o = {}
    setmetatable(o, {__index = GlobalMonitor})
    return o
end

-- 检测区域内是否有玩家
function GlobalMonitor:checkPlayer()
    -- print("检测区域内是否有玩家...")
    
    local region = Config.PLAYER_DETECTION_REGION
    local x, y = -1, -1
    local ret, x, y = findPic(region[1], region[2], region[3], region[4], "player.bmp", "101010", 0, 0.9)
    
    if x ~= -1 and y ~= -1 then
        print("检测到玩家！坐标: " .. x .. ", " .. y)
        toast("检测到玩家！坐标: " .. x .. ", " .. y)
        return true
    else
        toast("未检测到玩家")
        return false
    end
end

-- 执行回城操作
function GlobalMonitor:returnToCity()
    print("检测到玩家，执行回城操作...")
    
    -- 点击回城按钮
    local returnBtn = Config.coordinates.battle.returnToCityButton
    tap(returnBtn.x, returnBtn.y)
    sleep(2000)  -- 等待回城操作完成
    
    print("回城操作已执行")
    return true
end

-- 检查红包
function GlobalMonitor:checkRedPacket()
    print("检查红包...")
    
    -- 点击打怪送红包
    local coords = Config.coordinates.redPacket
    tap(coords.enterButton.x, coords.enterButton.y)
    sleep(2000)
    
    tap(coords.openTenTimes.x, coords.openTenTimes.y)
    sleep(2000)  -- 等待动画完成
    
    -- 关闭红包窗口
    tap(coords.closeButton.x, coords.closeButton.y)
    sleep(1000)
    
    print("红包领取完成")
end

return GlobalMonitor 