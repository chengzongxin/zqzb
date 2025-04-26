-- 最强战兵Boss狩猎模块

-- 导入配置
local Config = require("config")

-- 创建Boss狩猎模块
local BossHunt = {}

-- 检查小地图是否打开
function BossHunt.isOpenMiniMap()
    print("检查小地图是否已打开...")
    
    -- 使用findPic函数查找小地图标志
    local x, y = -1, -1
    local ret, x, y = findPic(735, 46, 1080, 160, "minimap.png", "101010", 0, 0.9)
    
    if x ~= -1 and y ~= -1 then
        print("小地图已打开")
        return true
    else
        print("小地图未打开，正在打开...")
        -- 点击打开小地图的按钮
        tap(Config.coordinates.battle.miniMapButton.x, Config.coordinates.battle.miniMapButton.y)
        sleep(1000)
        
        -- 再次检查是否成功打开
        ret, x, y = findPic(735, 46, 1080, 160, "minimap.png", "101010", 0, 0.9)
        return x ~= -1 and y ~= -1
    end
end

-- 关闭小地图
function BossHunt.closeMiniMap()
    print("关闭小地图...")
    -- 点击关闭小地图按钮
    tap(1470, 114)
    sleep(500)
    print("小地图已关闭")
end

-- 寻找Boss (简单两轮查找)
function BossHunt.findBoss()
    print("开始寻找Boss（两轮查找）...")
    
    local foundBoss = false
    local maxSearchRounds = 2  -- 设置两轮查找
    
    for round = 1, maxSearchRounds do
        print("第" .. round .. "轮查找Boss...")
        
        -- 使用findPic函数查找Boss图标（支持多个图片模板）
        local x, y = -1, -1
        local ret, x, y = findPic(457, 197, 1174, 730, "boss2.bmp|boss1.bmp", "101010", 0, 0.7)
        
        if x ~= -1 and y ~= -1 then
            print("找到Boss，坐标: " .. x .. ", " .. y)
            -- 点击Boss图标，前往Boss位置
            tap(x, y)
            sleep(1000)
            foundBoss = true
            break  -- 找到Boss后跳出循环
        else
            print("第" .. round .. "轮未找到Boss")
            -- 简单等待一小段时间再次查找
            sleep(500)
        end
    end
    
    -- 关闭小地图
    BossHunt.closeMiniMap()
    
    if foundBoss then
        print("成功找到Boss!")
    else
        print("两轮查找均未找到Boss")
    end
    
    return foundBoss
end

-- 检查是否正在寻路
function BossHunt.isPathfinding()
    print("检查是否正在寻路中...")
    
    -- 寻路提示区域
    local pathfindRegion = {700,582,942,692}
    
    
    -- 寻路检测次数
    local maxChecks = 3
    local foundCount = 0
    
    -- 多次检测，防止误判
    for i = 1, maxChecks do
        -- 在指定区域查找寻路提示图片
        local x, y = -1, -1
        -- local ret, x, y = findPic(pathfindRegion[1], pathfindRegion[2], pathfindRegion[3], pathfindRegion[4], "findpath.png", "101010", 0, 0.8)
		local ret, x, y = findPic(pathfindRegion[1], pathfindRegion[2], pathfindRegion[3], pathfindRegion[4],"findpath.png","333333",0,0.7)
        
        if x ~= -1 and y ~= -1 then
            print("第" .. i .. "次检测：正在寻路中")
            foundCount = foundCount + 1
        else
            print("第" .. i .. "次检测：未发现寻路提示")
        end
        
        -- 短暂延迟，避免过于频繁的检测
        sleep(200)
    end
    
    -- 只要有一次检测到就认为在寻路中
    return foundCount > 0
end

-- 等待到达Boss位置
function BossHunt.waitForArrival()
    print("等待到达Boss位置...")
    
    -- 最大等待时间（毫秒）
    local maxWaitTime = 180 * 1000  -- 最多等待180秒
    local startTime = os.time() * 1000
    
    -- 循环检测是否仍在寻路
    while (os.time() * 1000 - startTime) < maxWaitTime do
        if BossHunt.isPathfinding() then
            print("仍在寻路中，继续等待...")
            sleep(200)  -- 等待3秒再次检测
        else
            print("已到达目的地")
            return true
        end
    end
    
    print("等待超时，可能未能到达Boss位置")
    return false
end

-- 开始自动战斗
function BossHunt.startAutoFight()
    print("开始自动战斗...")
    
    -- 使用tap点击自动战斗按钮
    local autoFightBtn = Config.coordinates.battle.autoFightButton
    tap(autoFightBtn.x, autoFightBtn.y)
    sleep(500)
    
    print("已开始自动战斗")
    return true
end

-- 完整的Boss狩猎流程
function BossHunt.huntBoss()
    print("开始Boss狩猎流程...")
    
    -- 打开小地图
    if not BossHunt.isOpenMiniMap() then
        print("无法打开小地图，放弃Boss狩猎")
        return false
    end
    
    -- 寻找Boss
    if not BossHunt.findBoss() then
        print("未找到Boss，将进行普通打怪")
        return false
    end
    
    -- 等待到达Boss位置
    if not BossHunt.waitForArrival() then
        print("未能到达Boss位置，将进行普通打怪")
        return false
    end
    
    -- 开始自动战斗
    BossHunt.startAutoFight()
    
    -- 使用分段等待的方式，方便检测玩家
    local bossFightTime = Config.BOSS_FIGHT_TIME or (3 * 60 * 1000)  -- 默认3分钟
    local startTime = os.time() * 1000
    local endTime = startTime + bossFightTime
    local checkInterval = Config.PLAYER_DETECTION_INTERVAL
    
    local battle = require("battle") -- 导入battle模块用于调用检测玩家方法
    
    while (os.time() * 1000) < endTime do
        -- 计算下一次检测前需要等待的时间
        local waitTime = math.min(checkInterval, endTime - (os.time() * 1000))
        if waitTime <= 0 then break end
        
        -- 短暂等待
        sleep(waitTime)
        
        -- 检测是否有玩家（如果启用了该功能）
        if Config.PLAYER_DETECTION_ENABLED then
            if battle.checkForPlayers() then
                -- 检测到玩家，执行回城操作
                battle.returnToCity()
                print("Boss战斗中检测到玩家，已终止战斗并回城")
                return true -- 仍然返回true因为已经找到并开始打Boss
            end
        end
    end
    
    print("Boss战斗完成")
    return true
end

return BossHunt 