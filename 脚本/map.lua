-- 地图基类
local Config = require("config")
local GlobalMonitor = require("global_monitor")
local BossHunt = require("bosshunt")

local Map = {}

-- 构造函数
function Map:new(o)
    o = o or {
        enabled = true,
        timeRestricted = false,
        validTimeRange = {0, 24},
        entryLimit = nil,
        entryCount = 0
    }
    setmetatable(o, {__index = Map})
    return o
end

-- 检查是否可以进入地图
function Map:canEnter()
    -- 如果地图未启用，直接返回false
    if not self.enabled then
        return false
    end
    
    -- 检查时间限制
    if self.timeRestricted and self.validTimeRange then
        local hour = tonumber(os.date("%H"))
        local canEnter = false
        
        -- 遍历所有时间段
        for i = 1, #self.validTimeRange, 2 do
            local startHour = self.validTimeRange[i]
            local endHour = self.validTimeRange[i + 1]
            
            -- 处理跨天的情况（如18:00-06:00）
            if startHour > endHour then
                if hour >= startHour or hour < endHour then
                    canEnter = true
                    break
                end
            else
                if hour >= startHour and hour < endHour then
                    canEnter = true
                    break
                end
            end
        end
        
        if not canEnter then
            print("当前时间不在允许进入的时间段内")
            return false
        end
    end
    
    -- 检查进入次数限制
    if self.entryLimit and self.entryCount >= self.entryLimit then
        print("已达到今日进入次数限制")
        return false
    end
    
    return true
end

-- 进入地图
function Map:enter()
    print("进入地图: " .. self.name)
    return true
end

-- 开始战斗
function Map:startFighting()
    print("开始战斗...")
    -- tap(1467, 415)  -- 自动战斗按钮
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
    -- if Config.BOSS_HUNT_ENABLED then
        print("尝试寻找Boss...")
        bossHunted = BossHunt.huntBoss()
        
        -- 如果只打Boss模式且已击杀Boss，则直接返回
        -- if bossHunted and Config.ONLY_BOSS_MODE then
            -- print("已击杀Boss，根据设置将直接切换地图")
            -- return
        -- end
    -- end
    
    -- 如果没有找到Boss或者Boss已经击杀完成且不是只打Boss模式，则继续常规打怪
    print("执行常规打怪...")
    
    -- 如果需要点击自动战斗按钮
    if Config.AUTO_ATTACK then
        self:startFighting()
    end
    
    -- 计算剩余打怪时间
    local remainingTime = self.fightTime
    if bossHunted then
        -- 如果打过Boss，减去Boss战斗时间
        remainingTime = self.fightTime - Config.BOSS_FIGHT_TIME
        if remainingTime < 0 then remainingTime = 0 end
    end
    
    -- 不再使用一次性sleep，而是分段sleep并检测玩家
    local startTime = os.time() * 1000
    local endTime = startTime + remainingTime
    local checkInterval = Config.PLAYER_DETECTION_INTERVAL
    
    while (os.time() * 1000) < endTime do
        -- 计算下一次检测前需要等待的时间
        local waitTime = math.min(checkInterval, endTime - (os.time() * 1000))
        if waitTime <= 0 then break end
        
        -- 短暂等待
        sleep(waitTime)
        
        -- 检测是否有玩家（如果启用了该功能）
        if Config.PLAYER_DETECTION_ENABLED then
            if GlobalMonitor:checkPlayer() then
                -- 检测到玩家，执行回城操作
                GlobalMonitor:returnToCity()
                print("检测到玩家，已终止打怪并回城")
                return
            end
        end
    end
    
    print(self.name .. " 打怪完成")
end

return Map 