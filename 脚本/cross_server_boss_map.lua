-- 跨服BOSS地图类
local Map = require("map")

local CrossServerBossMap = {}
setmetatable(CrossServerBossMap, {__index = Map})

-- 构造函数
function CrossServerBossMap:new(name, fightTime, priority, layers)
    local o = Map:new(name, "cross_server_boss", fightTime, priority)
    o.layers = layers or {}
    o.currentLayer = 1
    setmetatable(o, {__index = CrossServerBossMap})
    return o
end

-- 检查BOSS是否刷新
function CrossServerBossMap:checkBossRefresh()
    print("检查 " .. self.name .. " 的BOSS是否刷新...")
    
    -- 依次检查每个楼层
    for _, layer in ipairs(self.layers) do
        print("检查" .. layer.name .. "...")
        
        -- 点击对应楼层
        tap(layer.x, layer.y)
        sleep(1000)
        
        -- 检查是否刷新
        local ret, x, y = findStr(layer.refreshCheckRegion[1], layer.refreshCheckRegion[2],
                                 layer.refreshCheckRegion[3], layer.refreshCheckRegion[4],
                                 "已刷新", "00FF00", 0.90)
        
        if x >= 0 and y >= 0 then
            print(layer.name .. " BOSS已刷新，坐标: " .. x .. ", " .. y)
            -- 点击立即挑战
            tap(layer.challengeButton.x, layer.challengeButton.y)
            sleep(3000)
            return true
        else
            print(layer.name .. " BOSS未刷新")
        end
    end
    
    -- 所有楼层都未刷新，点击关闭按钮
    print("所有楼层都未刷新，点击关闭按钮")
    tap(1324, 125)
    sleep(1000)
    return false
end

-- 开始打怪
function CrossServerBossMap:startFighting()
    Map.startFighting(self)  -- 调用父类方法
    
    -- 检查BOSS是否刷新
    if self:checkBossRefresh() then
        print("BOSS已刷新，开始战斗")
        -- 开始自动战斗
        tap(1467, 415)  -- 自动战斗按钮
        sleep(1000)
    else
        print("BOSS未刷新，跳过此地图")
        return false
    end
    
    return true
end

return CrossServerBossMap 