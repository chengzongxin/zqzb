-- 游戏管理器类
local Config = require("config")
local GlobalMonitor = require("global_monitor")
local Battle = require("battle")
local BossHunt = require("bosshunt")
local RedPacket = require("redpacket")

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
        },
        config = {}  -- 配置信息
    }
    setmetatable(o, {__index = GameManager})
    
    -- 默认启用所有地图
    for _, map in ipairs(o.maps) do
        map.enabled = true
    end
    
    return o
end

-- 检查红包
function GameManager:checkRedPacket()
    local currentTime = os.time() * 1000
    if currentTime - self.lastRedPacketTime >= Config.COLLECT_REDPACKET_INTERVAL then
        print("检查红包...")
        RedPacket.collect()
        self.lastRedPacketTime = currentTime
    end
end

-- 更新配置
function GameManager:updateConfig(newConfig)
    self.config = newConfig
    print("配置已更新")
    
    if type(newConfig) == "string" then
        newConfig = jsonLib.decode(newConfig)
    end
    
    if type(newConfig) ~= "table" then
        print("UI配置无效")
        return
    end
    
    -- 更新基本设置
    if newConfig.idAutoEnabled then
        Config.AUTO_ATTACK = newConfig.idAutoEnabled == "true"
    end
    
    if newConfig.idPlayerDetection then
        Config.PLAYER_DETECTION_ENABLED = newConfig.idPlayerDetection == "true"
    end
    
    -- 更新地图设置
    for i, map in ipairs(self.maps) do
        local enabledKey = "mapEnabled_" .. i
        local timeKey = "mapTime_" .. i
        
        if newConfig[enabledKey] then
            map.enabled = newConfig[enabledKey] == "true"
        end
        
        if newConfig[timeKey] then
            local minutes = tonumber(newConfig[timeKey]) or 5
            map.fightTime = minutes * 60 * 1000
        end
    end
end

-- 进入下一个地图
function GameManager:nextMap()
    self.currentMapIndex = self.currentMapIndex + 1
    if self.currentMapIndex > #self.maps then
        self.currentMapIndex = 1
    end
    print("切换到下一个地图: " .. self.maps[self.currentMapIndex].name)
    
    -- 在切换地图时检查红包
    self:checkRedPacket()
end

-- 运行游戏
function GameManager:run()
    print("游戏管理器启动")
    toast("游戏管理器启动", 0, 0, 12)
    
    while true do
        local currentMap = self.maps[self.currentMapIndex]
        print("当前地图: " .. currentMap.name)
        
        -- 1. 检查是否可以进入地图
        if not currentMap:canEnter() then
            self:nextMap()
            sleep(1000)
            goto continue
        end
        
        -- 2. 尝试进入地图
        if not currentMap:enter() then
            self:nextMap()
            sleep(1000)
            goto continue
        end
        
        -- 3. 开始打怪
        currentMap:fightInMap()
        
        -- 4. 进入下一个地图
        self:nextMap()
        sleep(1000)
        
        ::continue::
    end
end

return GameManager 