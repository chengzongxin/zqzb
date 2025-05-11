-- 寻路功能模块
local CoordinateReader = require("coordinate_reader")
local reader = CoordinateReader
local MoveMode = require("move_mode")  -- 导入移动模式工具

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

-- 计算到目标点的距离
function PathFinder:calculateDistance(currentX, currentY, targetX, targetY)
    local xDiff = math.abs(currentX - targetX)
    local yDiff = math.abs(currentY - targetY)
    return math.sqrt(xDiff * xDiff + yDiff * yDiff)
end

-- 移动到目标位置
function PathFinder:moveToTarget(targetX, targetY)
    print("开始寻路到目标位置: " .. targetX .. ":" .. targetY)
    
    -- 确保开始时是跑步模式
    MoveMode:switchToRunning()
    
    -- 设置超时时间（60秒）
    local timeout = 60 * 1000  -- 60秒
    local startTime = os.time() * 1000
    
    while not self:isAtTarget(targetX, targetY) do
        -- 检查是否超时
        local currentTime = os.time() * 1000
        if currentTime - startTime > timeout then
            print("寻路超时，未能到达目标位置")
            toast("寻路超时，未能到达目标位置", 0, 0, 12)
            return false
        end
        
        local currentX, currentY = reader:getCurrentCoordinate()
        if not currentX or not currentY then
            print("无法获取当前坐标，重试...")
            sleep(1000)
            goto continue
        end
        
        print("当前位置: " .. currentX .. ":" .. currentY)
        
        -- 计算到目标点的距离
        local distance = self:calculateDistance(currentX, currentY, targetX, targetY)
        
        -- 当距离小于4个像素时切换到走路模式
        if distance < 4 then
            MoveMode:switchToWalking()
        else
            MoveMode:switchToRunning()
        end
        
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
    
    -- 到达目标位置后切换回跑步模式
    MoveMode:switchToRunning()
    
    print("已到达目标位置")
    toast("已到达目标位置: " .. targetX .. ":" .. targetY, 0, 0, 12)
    return true
end

return PathFinder 