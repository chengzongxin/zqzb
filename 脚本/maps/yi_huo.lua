local Map = require("map")

local YiHuo = {}
setmetatable(YiHuo, {__index = Map})

function YiHuo:new()
    local o = Map:new({
        name = "异火一层",
        fightTime = 15 * 60 * 1000,  -- 15分钟
        priority = 100
    })
    setmetatable(o, {__index = YiHuo})
    return o
end

function YiHuo:enterFunction()
    print("开始进入异火一层...")
    
    -- 点击异火
    tap(376, 375)
    sleep(1000)
    
    -- 点击进入
    tap(456, 313)
    sleep(2000)
    
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
        print("BOSS未刷新")
        -- 点击关闭按钮
        tap(1324, 125)
        sleep(1000)
        return false
    end
end

function YiHuo:startFighting()
    print("开始在地图 " .. self.name .. " 打怪，持续 " .. (self.fightTime/1000/60) .. " 分钟")
    tap(1467, 415)  -- 自动战斗按钮
    sleep(1000)
    return true
end

function YiHuo:leave()
    return true
end

return YiHuo 