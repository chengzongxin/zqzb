-- 最强战兵脚本配置文件

-- 全局配置参数
Config = {
    -- 战斗相关配置
    FIGHT_TIME = 5 * 60 * 1000,  -- 每个地图打怪时间（毫秒），这里设置为5分钟
    AUTO_ATTACK = true,          -- 是否需要点击自动战斗按钮
    BOSS_HUNT_ENABLED = true,    -- 是否启用Boss狩猎功能
    ONLY_BOSS_MODE = false,      -- 是否只打Boss模式（打完Boss立即切换地图）
    BOSS_FIGHT_TIME = 5 * 60 * 1000,  -- Boss战斗时间（毫秒）
    
    -- 玩家检测相关
	PLAYER_DETECTION_SWICH_PLAYER_REGION = {0, 140, 374, 407}, -- 检查是否切换玩家列表
    PLAYER_DETECTION_ENABLED = true,  -- 是否启用玩家检测功能
    PLAYER_DETECTION_REGION = {49, 138, 346, 411},  -- 玩家检测区域
    PLAYER_DETECTION_INTERVAL = 5 * 1000,  -- 玩家检测间隔（毫秒）
    
    -- 红包相关配置
    COLLECT_REDPACKET_INTERVAL = 10 * 60 * 1000, -- 领红包间隔，默认10分钟
    
    -- 地图数据
    maps = {
        -- 特殊BOSS地图放在最前面
        {name="异火二层", type="special_boss", fightTime=15*60*1000, -- 10分钟
            enterSteps={
                {action="tap", x=1088, y=85},   -- 点击福利boss
                {action="tap", x=1365, y=336},  -- 点击异火
                {action="tap", x=376, y=375},   -- 点击异火一层
                {action="check_boss_refresh"},  -- 特殊操作：检查boss是否刷新
            }
        },
        
        -- 特殊地图
        {name="酆都鬼蜮", type="special", timeRestricted=true, fightTime=10*60*1000, -- 10分钟
            enterSteps={
                {action="tap", x=1300, y=54},
                {action="tap", x=672, y=204},
                {action="swipe", x1=1053, y1=731, x2=1056, y2=410, duration=200},
                {action="swipe", x1=1053, y1=731, x2=1056, y2=410, duration=200},
                {action="swipe", x1=1053, y1=731, x2=1056, y2=410, duration=200},
                {action="tap", x=1202, y=418},
                {action="tap", x=482, y=597}
            }
        },
        {name="斗罗大世界", type="special", fightTime=10*60*1000, -- 10分钟
            enterSteps={
                {action="tap", x=1300, y=54},
                {action="tap", x=672, y=204},
                {action="swipe", x1=1053, y1=731, x2=1056, y2=410, duration=200},
                {action="swipe", x1=1053, y1=731, x2=1056, y2=410, duration=200},
                {action="swipe", x1=1053, y1=731, x2=1056, y2=410, duration=200},
                {action="tap", x=1182, y=570},
                {action="tap", x=461, y=305}
            }
        },
        {name="欲界六重天", type="special", fightTime=10*60*1000, -- 10分钟
            enterSteps={
                {action="tap", x=1300, y=54},
                {action="tap", x=672, y=204},
                {action="swipe", x1=1053, y1=731, x2=1056, y2=410, duration=200},
                {action="swipe", x1=1053, y1=731, x2=1056, y2=410, duration=200},
                {action="swipe", x1=1053, y1=731, x2=1056, y2=410, duration=200},
                {action="tap", x=1193, y=736},
                {action="tap", x=1163, y=732}
            }
        },
        
        -- 十六大陆地图放在后面
        {name="黑魔门", x=415, y=445, dialog_x=456, dialog_y=313, type="continent16", fightTime=3*60*1000}, -- 5分钟
        {name="风火门", x=521, y=392, dialog_x=456, dialog_y=313, type="continent16", fightTime=3*60*1000}, -- 5分钟
        {name="冥月东教", x=611, y=319, dialog_x=456, dialog_y=313, type="continent16", fightTime=3*60*1000}, -- 5分钟
        {name="冥月西教", x=706, y=261, dialog_x=456, dialog_y=313, type="continent16", fightTime=3*60*1000}, -- 5分钟
    },
    
    -- 坐标数据
    coordinates = {
        -- 大陆飞行相关
        continent = {
            flyButton = {x=1377, y=322},  -- 大陆直飞按钮
            sixteenContinent = {x=732, y=585}  -- 十六大陆选项
        },
        
        -- 红包相关
        redPacket = {
            enterButton = {x=117, y=457},    -- 打怪送红包按钮
            openTenTimes = {x=612, y=703},   -- 开启10次按钮
            closeButton = {x=1332, y=131}    -- 关闭红包窗口按钮
        },
        
        -- 战斗相关
        battle = {
            autoFightButton = {x=1467, y=415},  -- 自动战斗按钮（已更新为正确坐标）
            miniMapButton = {x=1498, y=131},  -- 小地图按钮位置
            autoFightKey = "z",  -- 自动战斗快捷键（保留但不再使用）
            returnToCityButton = {x=1465, y=323},  -- 回城按钮坐标，请根据实际情况调整
        }
    }
}

return Config 