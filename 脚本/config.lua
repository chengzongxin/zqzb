-- 最强战兵脚本配置文件
-- local Map = require("map")

-- 全局配置
Config = {
    -- 战斗相关配置
    AUTO_ATTACK = true,          -- 是否需要点击自动战斗按钮
    PLAYER_DETECTION_ENABLED = true,  -- 是否启用玩家检测功能
    PLAYER_DETECTION_REGION = {49, 138, 346, 411},  -- 玩家检测区域
    PLAYER_DETECTION_INTERVAL = 5 * 1000,  -- 玩家检测间隔（毫秒）
    BOSS_FIGHT_TIME = 3 * 60 * 1000,  -- BOSS战斗时间，默认3分钟
    BOSS_HUNT_ENABLED = true,  -- 是否启用BOSS狩猎功能
    ONLY_BOSS_MODE = false,  -- 是否只打BOSS模式
    
    -- 红包相关配置
    COLLECT_REDPACKET_INTERVAL = 10 * 60 * 1000, -- 领红包间隔，默认10分钟
    
    -- 坐标数据
    coordinates = {
        -- 战斗相关
        battle = {
            autoFightButton = {x=1467, y=415},
            miniMapButton = {x=1498, y=131},
            returnToCityButton = {x=1465, y=323}
        },
        
        -- 红包相关
        redPacket = {
            enterButton = {x=117, y=457},
            openTenTimes = {x=612, y=703},
            closeButton = {x=1332, y=131}
        }
    }
}

return Config 