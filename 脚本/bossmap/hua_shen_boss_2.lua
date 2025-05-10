local Map = require("map")

local HuaShenBoss2 = {}
setmetatable(HuaShenBoss2, {__index = Map})

function HuaShenBoss2:new()
    local o = Map:new({
        name = "化身跨服BOSS二层",
        fightTime = 15 * 60 * 1000,  -- 30分钟
        priority = 90,
        timeRestricted = true,
        validTimeRange = {22, 23}  -- 12:00-14:00
    })
    setmetatable(o, {__index = HuaShenBoss2})
    return o
end

function HuaShenBoss2:enter()
    print("开始进入化身跨服BOSS二层...")
    
    -- 点击福利BOSS
    tap(1082, 89)
    sleep(1000)
    
    -- 点击化身
    tap(1368, 458)
    sleep(1000)
      
    -- 检查是否挑战了3次
    setDict(0,"1.txt")
    useDict(0)
    local ret,x,y = findStr(514, 160, 1316, 780, "3-3","00FF00|00FF00", 0.90)
    if x >=0 and y >= 0 then
        print("已挑战3次，跳过此地图")
        -- 点击关闭按钮
        tap(1324, 125)
        sleep(1000)
        return false
    end
    
    -- 点击二层
    tap(386, 688)
    sleep(1000)
    
    -- 检查BOSS是否刷新
    setDict(0, "1.txt")
    useDict(0)
    
    local ret, x, y = findStr(514, 160, 1316, 780, "化身已刷新", "00FF00", 0.90)
    if x >= 0 and y >= 0 then
        print("BOSS已刷新，坐标: " .. x .. ", " .. y)
        -- 点击立即挑战
        tap(921, 741)
        sleep(3000)  -- 等待进入地图
        return true
    else
        print("BOSS未刷新，跳过此地图")
        -- 点击关闭按钮
        tap(1324, 125)
        sleep(1000)
        return false
    end
end

function HuaShenBoss2:startFighting()
    return Map.startFighting(self)
end

function HuaShenBoss2:fightInMap()
    return Map.fightInMap(self)
end

function HuaShenBoss2:leave()
    return Map.leave(self)
end

return HuaShenBoss2 