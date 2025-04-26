-- 游戏管理器类
local Config = require("config")
local GlobalMonitor = require("global_monitor")
local Battle = require("battle")
local BossHunt = require("bosshunt")

-- 导入所有地图类
local YiHuo1 = require("maps/yihuo_level1")
local HuaShenBoss1 = require("maps/hua_shen_boss_1")
local HuaShenBoss2 = require("maps/hua_shen_boss_2")
local HuaShenBoss3 = require("maps/hua_shen_boss_3")
local FengDu = require("maps/feng_du")
local DouLuo = require("maps/dou_luo")
local HeiMo = require("maps/hei_mo")
local FengHuo = require("maps/feng_huo")
local MingYueDong = require("maps/ming_yue_dong")
local MingYueXi = require("maps/ming_yue_xi")

local GameManager = {}

-- 构造函数
function GameManager:new()
    local o = {
        currentMapIndex = 1,
        lastRedPacketTime = 0,
        lastPlayerCheckTime = 0,
        maps = {
            YiHuo1:new(),           -- 异火一层
            HuaShenBoss1:new(),    -- 化身跨服BOSS一层
            HuaShenBoss2:new(),    -- 化身跨服BOSS二层
            HuaShenBoss3:new(),    -- 化身跨服BOSS三层
            FengDu:new(),          -- 酆都鬼蜮
            DouLuo:new(),          -- 斗罗大世界
            HeiMo:new(),           -- 黑魔门
            FengHuo:new(),         -- 风火门
            MingYueDong:new(),     -- 冥月东教
            MingYueXi:new()        -- 冥月西教
        }
    }
    setmetatable(o, {__index = GameManager})
    return o
end

-- 更新配置
function GameManager:updateConfig(uiConfig)
    if type(uiConfig) == "string" then
        uiConfig = jsonLib.decode(uiConfig)
    end
    
    if type(uiConfig) ~= "table" then
        print("UI配置无效")
        return
    end
    
    -- 更新基本设置
    if uiConfig.idAutoEnabled then
        Config.AUTO_ATTACK = uiConfig.idAutoEnabled == "true"
    end
    
    if uiConfig.idPlayerDetection then
        Config.PLAYER_DETECTION_ENABLED = uiConfig.idPlayerDetection == "true"
    end
    
    -- 更新地图设置
    for i, map in ipairs(self.maps) do
        local enabledKey = "mapEnabled_" .. i
        local timeKey = "mapTime_" .. i
        
        if uiConfig[enabledKey] then
            map.enabled = uiConfig[enabledKey] == "true"
        end
        
        if uiConfig[timeKey] then
            local minutes = tonumber(uiConfig[timeKey]) or 5
            map.fightTime = minutes * 60 * 1000
        end
    end
end

-- 获取下一个有效地图
function GameManager:getNextValidMap()
    local startIndex = self.currentMapIndex
    local mapCount = #self.maps
    
    -- 按优先级排序地图
    local sortedMaps = {}
    for i, map in ipairs(self.maps) do
        table.insert(sortedMaps, map)
    end
    table.sort(sortedMaps, function(a, b) return a.priority > b.priority end)
    
    for i = 1, mapCount do
        local map = sortedMaps[i]
        if map.enabled then
            local canEnter, reason = map:canEnter()
            if canEnter then
                self.currentMapIndex = i
                return map
            else
                print(map.name .. " 无法进入: " .. reason)
            end
        end
    end
    
    return nil
end

-- 主循环
function GameManager:run()
    print("游戏管理器启动")
    toast("游戏管理器启动", 0, 0, 12)
    
    while true do
        -- 获取当前地图
        local map = self:getNextValidMap()
        if not map then
            print("没有可用的地图，等待1秒后重试")
            sleep(1000)
            goto continue
        end
        
        print("当前地图: " .. map.name)
        
        -- 进入地图
        if not map:enter() then
            print("进入地图失败，尝试下一个地图")
            goto continue
        end
        
        -- 开始挂机
        map:fightInMap()
        
        -- 离开地图
        map:leave()
        
        ::continue::
    end
end

return GameManager 