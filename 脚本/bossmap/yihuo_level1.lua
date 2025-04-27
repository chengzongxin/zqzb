local Map = require("map")

local YiHuo1 = {}
setmetatable(YiHuo1, {__index = Map})

function YiHuo1:new()
    local o = Map:new({
        name = "异火一层",
        fightTime = 15 * 60 * 1000,  -- 15分钟
        priority = 100
    })
    setmetatable(o, {__index = YiHuo1})
    return o
end

function YiHuo1:enter()
    print("开始进入异火一层...")
    
    -- 点击福利boss
    tap(1088, 85)
    sleep(1000)

    -- 点击异火
    tap(1365, 336)
    sleep(1000)

    -- 点击异火一层
    tap(376, 375)
    sleep(1000)
    
    -- 检查BOSS是否刷新
    setDict(0, "1.txt")
    useDict(0)
    
    local ret, x, y = findStr(514, 160, 1316, 780, "已刷新", "00FF00", 0.90)
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

function YiHuo1:startFighting()
    return Map.startFighting(self)
end

function YiHuo1:fightInMap()
    return Map.fightInMap(self)
end

function YiHuo1:leave()
    return Map.leave(self)
end

return YiHuo1 