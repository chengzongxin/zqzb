-- 移动模式切换工具
local MoveMode = {}

-- 检查当前移动模式
function MoveMode:checkCurrentMode()
    -- 检查是否在跑步模式
    local ret, x, y = findPic(0,0,0,0,"跑.png","101010",0,0.9)
    if ret ~= -1 then
        return "running"
    end
    
    -- 检查是否在走路模式
    local ret1, x1, y1 = findPic(0,0,0,0,"走.png","101010",0,0.9)
    if ret1 ~= -1 then
        return "walking"
    end
    
    -- 如果都没找到，默认为跑步模式
    return "running"
end

-- 切换到指定模式
function MoveMode:switchTo(mode)
    local currentMode = self:checkCurrentMode()
    
    -- 如果当前已经是目标模式，则不需要切换
    if currentMode == mode then
        print("当前已经是" .. (mode == "running" and "跑步" or "走路") .. "模式")
        return true
    end
    
    -- 点击切换按钮
    tap(47, 828)
    sleep(500)  -- 等待切换动画
    
    -- 验证是否切换成功
    local newMode = self:checkCurrentMode()
    if newMode == mode then
        print("成功切换到" .. (mode == "running" and "跑步" or "走路") .. "模式")
        return true
    else
        print("切换模式失败")
        return false
    end
end

-- 切换到跑步模式
function MoveMode:switchToRunning()
    return self:switchTo("running")
end

-- 切换到走路模式
function MoveMode:switchToWalking()
    return self:switchTo("walking")
end

return MoveMode 