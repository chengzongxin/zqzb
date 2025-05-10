-- 寻路功能模块
local CoordinateReader = require("coordinate_reader")
local reader = CoordinateReader

local PathFinder = {}

-- 检查是否到达目标位置
function PathFinder:isAtTarget(targetX, targetY)
    local currentX, currentY = reader:getCurrentCoordinate()
    if not currentX or not currentY then
        print("无法获取当前坐标")
        return false
    end
    
    -- 允许一定的误差范围（比如0个像素）
    local errorRange = 0
    local xDiff = math.abs(currentX - targetX)
    local yDiff = math.abs(currentY - targetY)
    
    return xDiff <= errorRange and yDiff <= errorRange
end

-- 移动到目标位置
function PathFinder:moveToTarget(targetX, targetY)
    print("开始寻路到目标位置: " .. targetX .. ":" .. targetY)
    
    while not self:isAtTarget(targetX, targetY) do
        local currentX, currentY = reader:getCurrentCoordinate()
        if not currentX or not currentY then
            print("无法获取当前坐标，重试...")
            sleep(1000)
            goto continue
        end
        
        print("当前位置: " .. currentX .. ":" .. currentY)
        
        -- 计算移动方向
        local moveX = 0
        local moveY = 0
        
        -- X轴移动
        if currentX > targetX then
            moveX = -1  -- 向左移动
        elseif currentX < targetX then
            moveX = 1   -- 向右移动
        end
        
        -- Y轴移动
        if currentY > targetY then
            moveY = -1  -- 向上移动
        elseif currentY < targetY then
            moveY = 1   -- 向下移动
        end
        
        -- 执行移动
        if moveX ~= 0 or moveY ~= 0 then
            print("移动方向: X=" .. moveX .. ", Y=" .. moveY)
            
            -- 根据方向执行滑动
            if moveX == -1 then
                -- 向左移动
                swipe(210, 678, 70, 678, 200)
            elseif moveX == 1 then
                -- 向右移动
                swipe(210, 678, 350, 678, 200)
            end
            
            if moveY == -1 then
                -- 向上移动
                swipe(210, 678, 210, 478, 200)
            elseif moveY == 1 then
                -- 向下移动
                swipe(210, 678, 210, 878, 200)
            end
            
            sleep(500)  -- 等待移动
        end
        
        ::continue::
    end
    
    print("已到达目标位置")
    toast("已到达目标位置: " .. targetX .. ":" .. targetY, 0, 0, 12)
    return true
end

return PathFinder 