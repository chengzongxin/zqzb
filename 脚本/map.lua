-- 地图基类
local Config = require("config")
local GlobalMonitor = require("global_monitor")
local BossHunt = require("bosshunt")

local Map = {}

-- 构造函数
function Map:new(o)
    o = o or {}
    setmetatable(o, {__index = Map})
    return o
end

-- 检查是否可以进入地图
function Map:canEnter()
    -- 检查是否启用
    if not self.enabled then
        return false, "地图未启用"
    end
    
    -- 检查时间限制
    if self.timeRestricted then
        local hour = tonumber(os.date("%H"))
        local validStart, validEnd = self.validTimeRange[1], self.validTimeRange[2]
        
        -- 处理跨天的情况（如18:00-06:00）
        if validStart > validEnd then
            if hour < validStart and hour >= validEnd then
                return false, "不在开放时间内"
            end
        else
            if hour < validStart or hour >= validEnd then
                return false, "不在开放时间内"
            end
        end
    end
    
    -- 检查进入次数限制
    if self.maxEntries and self.entryCount >= self.maxEntries then
        return false, "已达到最大进入次数"
    end
    
    return true
end

-- 进入地图
function Map:enter()
    print("进入地图: " .. self.name)
    
    -- 执行进入步骤
    for i, step in ipairs(self.enterSteps) do
        if step.action == "tap" then
            print("步骤 " .. i .. ": 点击坐标 (" .. step.x .. ", " .. step.y .. ")")
            tap(step.x, step.y)
            sleep(step.wait or 1000)
        elseif step.action == "swipe" then
            print("步骤 " .. i .. ": 滑动屏幕")
            swipe(step.x1, step.y1, step.x2, step.y2, step.duration)
            sleep(step.wait or 800)
        elseif step.action == "check_boss" then
            print("步骤 " .. i .. ": 检查BOSS是否刷新")
            if self.checkBossRefresh and self:checkBossRefresh() then
                return true
            else
                return false
            end
        end
    end
    
    -- 额外等待加载时间
    sleep(2000)
    print("已完成 " .. self.name .. " 的进入步骤")
    return true
end

-- 开始战斗
function Map:startFighting()
    print("开始战斗...")
    tap(1467, 415)  -- 自动战斗按钮
    sleep(1000)
end

-- 离开地图
function Map:leave()
    print("离开地图: " .. self.name)
    -- 默认不需要特殊操作
end

-- 在地图中挂机
function Map:fightInMap()
    print("开始在地图 " .. self.name .. " 挂机")
    
    -- 尝试寻找并击杀Boss
    local bossHunted = false
    if Config.BOSS_HUNT_ENABLED then
        print("尝试寻找Boss...")
        bossHunted = BossHunt.huntBoss()
        
        -- 如果只打Boss模式且已击杀Boss，则直接返回
        if bossHunted and Config.BOSS_HUNT_ENABLED and Config.ONLY_BOSS_MODE then
            print("已击杀Boss，根据设置将直接切换地图")
            return
        end
    end
    
    -- 计算剩余打怪时间
    local remainingTime = self.fightTime
    if bossHunted then
        -- 如果打过Boss，减去Boss战斗时间
        remainingTime = self.fightTime - Config.BOSS_FIGHT_TIME
        if remainingTime < 0 then remainingTime = 0 end
    end
    
    -- 开始自动战斗
    if Config.AUTO_ATTACK then
        self:startFighting()
    end
    
    -- 使用分段等待的方式，方便检测玩家和红包
    local startTime = os.time() * 1000
    local endTime = startTime + remainingTime
    local checkInterval = Config.PLAYER_DETECTION_INTERVAL
    
    while (os.time() * 1000) < endTime do
        -- 计算下一次检测前需要等待的时间
        local waitTime = math.min(checkInterval, endTime - (os.time() * 1000))
        if waitTime <= 0 then break end
        
        -- 短暂等待
        sleep(waitTime)
        
        -- 检查玩家（通过全局监控类）
        if Config.PLAYER_DETECTION_ENABLED and GlobalMonitor:checkPlayer() then
            print("检测到玩家，终止打怪并回城")
            GlobalMonitor:returnToCity()
            return
        end
        
        -- 检查红包
        if (os.time() * 1000 - self.lastRedPacketTime) >= Config.COLLECT_REDPACKET_INTERVAL then
            GlobalMonitor:checkRedPacket()
            self.lastRedPacketTime = os.time() * 1000
        end
    end
    
    print("地图 " .. self.name .. " 挂机完成")
end

return Map 