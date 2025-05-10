-- 游戏管理器类
local Config = require("config")
local GlobalMonitor = require("global_monitor")
local BossHunt = require("bosshunt")
local RedPacket = require("redpacket")

-- 导入所有地图类
-- bossmap
local YiHuo1 = require("bossmap/yihuo_level1")
local HuaShenBoss1 = require("bossmap/hua_shen_boss_1")
local HuaShenBoss2 = require("bossmap/hua_shen_boss_2")
local HuaShenBoss3 = require("bossmap/hua_shen_boss_3")

-- specialmap
local FengDu = require("specialmap/feng_du")
local DouLuo = require("specialmap/dou_luo")
local YuJie1 = require("specialmap/yu_jie_1")
local XingDou = require("specialmap/xing_dou")  -- 新增：导入星斗大森林

-- map16
local HeiMo = require("map16/hei_mo")
local FengHuo = require("map16/feng_huo")
local MingYueDong = require("map16/ming_yue_dong")
local MingYueXi = require("map16/ming_yue_xi")
local QingLan = require("map16/qing_lan")  -- 新增：导入青兰圣地

local GameManager = {}

-- 构造函数
function GameManager:new()
    local o = {
        currentMapIndex = 1,
        lastRedPacketTime = 0,
        lastPlayerCheckTime = 0,
        maps = {
            XingDou:new(),         -- 斗罗大世界-星斗大森林
            YiHuo1:new(),           -- 异火一层
            HuaShenBoss3:new(),    -- 化身跨服BOSS三层
            HuaShenBoss2:new(),    -- 化身跨服BOSS二层
            HuaShenBoss1:new(),    -- 化身跨服BOSS一层
            DouLuo:new(),          -- 斗罗大世界
            
            FengDu:new(),          -- 酆都鬼蜮
            YuJie1:new(),          -- 欲界一层
            HeiMo:new(),           -- 黑魔门
            FengHuo:new(),         -- 风火门
            MingYueDong:new(),     -- 冥月东教
            MingYueXi:new(),       -- 冥月西教
            QingLan:new()          -- 青兰圣地
        },
        config = {}  -- 配置信息
    }
    setmetatable(o, {__index = GameManager})
    
    -- 默认启用所有地图
    for _, map in ipairs(o.maps) do
        map.enabled = true
    end
    
    -- 执行初始化
    o:initialize()
    
    return o
end

-- 初始化方法
function GameManager:initialize()
    print("开始初始化游戏管理器...")
    
    -- 1. 检查并切换到玩家列表模式
    self:checkAndSwitchToPlayerListMode()
    
    -- 2. 检查并关闭任何弹窗
    self:checkAndClosePopup()
    
    -- 3. 初始化其他配置
    self.lastRedPacketTime = os.time() * 1000
    self.lastPlayerCheckTime = os.time() * 1000
    
    print("游戏管理器初始化完成")
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

-- 检测并关闭任何弹窗（简化版）
function GameManager:checkAndClosePopup()
    print("检测是否有弹窗...")
    local ret, x, y = findPic(0, 0, 0, 0, "关闭.png", "101010", 0, 0.7)
    print("弹窗检测结果:", ret, x, y)
    
    if ret ~= -1 then
        print("检测到弹窗，位置: x=" .. x .. ", y=" .. y)
        
        -- 点击关闭按钮
        tap(x, y)
        print("已点击关闭按钮")
        sleep(500) -- 给关闭动画一些时间
        return true
    else
        print("未检测到弹窗")
        return false
    end
end

-- 进入下一个地图
function GameManager:nextMap()
    self.currentMapIndex = self.currentMapIndex + 1
    if self.currentMapIndex > #self.maps then
        self.currentMapIndex = 1
    end
    print("切换到下一个地图: " .. self.maps[self.currentMapIndex].name)
end

-- 检查并切换到玩家列表模式
function GameManager:checkAndSwitchToPlayerListMode()
    print("检查是否已切换到玩家列表模式...")
    local region = {0, 140, 374, 407}
    local index = -1
    local ret = nil
    index, ret = findPicFast(region[1], region[2], region[3], region[4], "人物.png", "000000", 0, 0.9)
    print("检测结果:", index, ret)
    
    if index == -1 then
        -- 未找到人物.png，说明不在玩家列表模式，需要切换
        print("未处于玩家列表模式，正在切换...")
        tap(27, 272)
        sleep(1000) -- 等待切换完成
        
        -- 再次检查是否成功切换
        index, ret = findPicFast(region[1], region[2], region[3], region[4], "人物.png", "000000", 0, 0.9)
        if index ~= -1 then
            print("成功切换到玩家列表模式")
        else
            print("警告：切换到玩家列表模式失败，可能影响脚本运行")
        end
    else
        print("已处于玩家列表模式，无需切换")
    end
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

        -- 检查并关闭弹窗
        self:checkAndClosePopup()

        -- 在切换地图时检查红包
        self:checkRedPacket()
        
        -- 4. 进入下一个地图
        self:nextMap()
        sleep(1000)

        ::continue::
    end
end

return GameManager 