local Map = require("map")

local YuJie1 = {}
setmetatable(YuJie1, {__index = Map})

function YuJie1:new()
    local o = Map:new({
        name = "欲界一层",
        fightTime = 10 * 60 * 1000,  -- 10分钟
        priority = 70
    })
    setmetatable(o, {__index = YuJie1})
    return o
end

function YuJie1:enter()
    print("开始进入欲界一层...")
    
    -- 点击变强攻略
    tap(1300, 54)
    sleep(1000)
    
    -- 点击推荐打宝
    tap(672, 204)
    sleep(1000)
    
    -- 滑动屏幕
    swipe(1053, 731, 1056, 410, 200)
    sleep(800)
    swipe(1053, 731, 1056, 410, 200)
    sleep(800)
    
    -- 点击欲界六重天
    tap(1193, 736)
    sleep(1000)
    
    -- 点击进入
    tap(1163, 732)
    sleep(2000)
    
    return true
end

function YuJie1:startFighting()
    return Map.startFighting(self)
end

function YuJie1:fightInMap()
    return Map.fightInMap(self)
end

function YuJie1:leave()
    return Map.leave(self)
end

return YuJie1