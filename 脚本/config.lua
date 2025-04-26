-- 最强战兵脚本配置文件
local Map = require("map")

-- 全局配置
Config = {
    -- 战斗相关配置
    AUTO_ATTACK = true,          -- 是否需要点击自动战斗按钮
    PLAYER_DETECTION_ENABLED = true,  -- 是否启用玩家检测功能
    PLAYER_DETECTION_REGION = {49, 138, 346, 411},  -- 玩家检测区域
    PLAYER_DETECTION_INTERVAL = 5 * 1000,  -- 玩家检测间隔（毫秒）
    
    -- 红包相关配置
    COLLECT_REDPACKET_INTERVAL = 10 * 60 * 1000, -- 领红包间隔，默认10分钟
    
    -- 地图配置
    maps = {
        -- 异火一层
        Map:new({
            name = "异火一层",
            fightTime = 15 * 60 * 1000,
            priority = 100,
            enterSteps = {
                {action="tap", x=376, y=375, wait=1000},
                {action="tap", x=456, y=313, wait=2000}
            },
            checkBossRefresh = function(self)
                local ret, x, y = findStr(514, 160, 1316, 780, "已刷新", "00FF00", 0.90)
                if x >= 0 and y >= 0 then
                    tap(921, 741)
                    sleep(3000)
                    return true
                end
                tap(1324, 125)
                sleep(1000)
                return false
            end
        }),
        
        -- 化身跨服BOSS
        Map:new({
            name = "化身跨服BOSS",
            fightTime = 30 * 60 * 1000,
            priority = 90,
            timeRestricted = true,
            validTimeRange = {12, 14},  -- 12:00-14:00
            enterSteps = {
                {action="tap", x=1300, y=54, wait=1000},
                {action="tap", x=672, y=204, wait=1000},
                {action="check_boss"}
            },
            checkBossRefresh = function(self)
                local floors = {
                    {name="一层", x=377, y=755},
                    {name="二层", x=379, y=694},
                    {name="三层", x=402, y=630}
                }
                
                for _, floor in ipairs(floors) do
                    print("检查" .. floor.name .. "...")
                    tap(floor.x, floor.y)
                    sleep(1000)
                    
                    local ret, x, y = findStr(514, 160, 1316, 780, "已刷新", "00FF00", 0.90)
                    if x >= 0 and y >= 0 then
                        tap(921, 741)
                        sleep(3000)
                        return true
                    end
                end
                
                tap(1324, 125)
                sleep(1000)
                return false
            end
        }),
        
        -- 酆都鬼蜮
        Map:new({
            name = "酆都鬼蜮",
            fightTime = 10 * 60 * 1000,
            priority = 80,
            timeRestricted = true,
            validTimeRange = {18, 6},  -- 18:00-06:00
            enterSteps = {
                {action="tap", x=1300, y=54, wait=1000},
                {action="tap", x=672, y=204, wait=1000},
                {action="swipe", x1=1053, y1=731, x2=1056, y2=410, duration=200, wait=800},
                {action="swipe", x1=1053, y1=731, x2=1056, y2=410, duration=200, wait=800},
                {action="swipe", x1=1053, y1=731, x2=1056, y2=410, duration=200, wait=800},
                {action="tap", x=1202, y=418, wait=1000},
                {action="tap", x=482, y=597, wait=2000}
            }
        }),
        
        -- 斗罗大世界
        Map:new({
            name = "斗罗大世界",
            fightTime = 10 * 60 * 1000,
            priority = 70,
            enterSteps = {
                {action="tap", x=1300, y=54, wait=1000},
                {action="tap", x=672, y=204, wait=1000},
                {action="swipe", x1=1053, y1=731, x2=1056, y2=410, duration=200, wait=800},
                {action="swipe", x1=1053, y1=731, x2=1056, y2=410, duration=200, wait=800},
                {action="swipe", x1=1053, y1=731, x2=1056, y2=410, duration=200, wait=800},
                {action="tap", x=1182, y=570, wait=1000},
                {action="tap", x=461, y=305, wait=2000}
            }
        }),
        
        -- 黑魔门
        Map:new({
            name = "黑魔门",
            fightTime = 3 * 60 * 1000,
            priority = 60,
            enterSteps = {
                {action="tap", x=1377, y=322, wait=1000},
                {action="tap", x=732, y=585, wait=1000},
                {action="tap", x=415, y=445, wait=1000},
                {action="tap", x=456, y=313, wait=2000}
            }
        }),
        
        -- 风火门
        Map:new({
            name = "风火门",
            fightTime = 3 * 60 * 1000,
            priority = 50,
            enterSteps = {
                {action="tap", x=1377, y=322, wait=1000},
                {action="tap", x=732, y=585, wait=1000},
                {action="tap", x=521, y=392, wait=1000},
                {action="tap", x=456, y=313, wait=2000}
            }
        })
    },
    
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