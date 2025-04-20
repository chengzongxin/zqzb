-- 最强战兵打怪模块

-- 导入配置
local Config = require("config")
local BossHunt = require("bosshunt")  -- 新增：导入Boss狩猎模块

-- 创建战斗模块
local Battle = {}

-- 前往十六大陆
function Battle.gotoSixteenContinent()
    print("正在前往十六大陆...")
    -- 点击大陆直飞
    tap(Config.coordinates.continent.flyButton.x, Config.coordinates.continent.flyButton.y)
    sleep(1000)
    
    -- 点击十六大陆
    tap(Config.coordinates.continent.sixteenContinent.x, Config.coordinates.continent.sixteenContinent.y)
    sleep(1000)
end

-- 前往指定地图
function Battle.gotoMap(mapIndex)
    local map = Config.maps[mapIndex]
    print("正在前往: " .. map.name)
    
    -- 检查酆都鬼蜮的时间限制
    if map.timeRestricted and not Battle.isValidTimeForFengdu() then
        print("当前时间不允许进入酆都鬼蜮（只在18:00-06:00开放）")
        -- 返回下一个有效地图索引
        -- return Config.maps[(mapIndex % #Config.maps) + 1]
        return nil
    end
    
    -- 根据地图类型选择不同的进入方式
    if map.type == "continent16" then
        -- 原有的十六大陆地图进入方式
        Battle.gotoSixteenContinent()
        
        -- 点击对应的打怪地点
        tap(map.x, map.y)
        sleep(1000)
        
        -- 对话框点击进入
        tap(map.dialog_x, map.dialog_y)
        sleep(2000)
        return map
    elseif map.type == "special" or map.type == "special_boss" then
        -- 特殊地图进入方式
        local success = Battle.enterSpecialMap(map)
        if not success and map.type == "special_boss" then
            -- 如果是因为BOSS未刷新而失败
            return nil  -- 返回nil表示无法进入该地图
        end
        return map
    end
    
    return map
end

-- 进入特殊地图（按照指定步骤）
function Battle.enterSpecialMap(map)
    print("使用特殊步骤进入地图: " .. map.name)
    
    -- 导入BOSS刷新检测模块（如果需要）
    local BossFresh = nil
    if map.type == "special_boss" then
        BossFresh = require("bossfresh")
    end
    
    -- 执行进入步骤
    for i, step in ipairs(map.enterSteps) do
        if step.action == "tap" then
            print("步骤 " .. i .. ": 点击坐标 (" .. step.x .. ", " .. step.y .. ")")
            tap(step.x, step.y)
            sleep(1000)  -- 每个点击后等待1秒
        elseif step.action == "swipe" then
            print("步骤 " .. i .. ": 滑动屏幕")
            swipe(step.x1, step.y1, step.x2, step.y2, step.duration)
            sleep(800)  -- 每次滑动后等待0.8秒
        elseif step.action == "check_boss_refresh" then
            print("步骤 " .. i .. ": 检查BOSS是否刷新")
            if BossFresh and BossFresh.checkBossRefreshed() then
                -- BOSS已刷新，点击挑战并进入地图
                BossFresh.challengeBoss()
                -- 进入异火二层地图后不需要额外操作，直接继续常规流程
                return true
            else
                -- BOSS未刷新，直接返回
                print("BOSS未刷新，无法挑战，将跳过此地图")
                return false
            end
        end
    end
    
    -- 额外等待加载时间
    sleep(2000)
    print("已完成 " .. map.name .. " 的进入步骤")
    return true
end

-- 检查是否在酆都鬼蜮开放时间内（18:00-06:00）
function Battle.isValidTimeForFengdu()
    local hour = tonumber(os.date("%H"))
    -- 18:00-23:59 或 00:00-06:00 是有效时间
    return (hour >= 18) or (hour < 6)
end

-- 在地图中打怪指定时间
function Battle.fightInMap(mapName, map, defaultDuration)
    -- 使用地图特定的挂机时间，如果没有则使用默认时间
    local duration = map.fightTime or defaultDuration
    
    print("开始在 " .. mapName .. " 打怪，将持续 " .. (duration/1000/60) .. " 分钟")
    
    -- 尝试寻找并击杀Boss
    local bossHunted = false
    if Config.BOSS_HUNT_ENABLED then
        print("尝试寻找Boss...")
        bossHunted = BossHunt.huntBoss()
        
        -- 如果只打Boss模式且已击杀Boss，则直接返回
        if bossHunted and Config.BOSS_HUNT_ENABLED and Config.ONLY_BOSS_MODE then
            print("已击杀Boss，根据设置将直接切换地图")
            return
        end
    end
    
    -- 如果没有找到Boss或者Boss已经击杀完成且不是只打Boss模式，则继续常规打怪
    print("执行常规打怪...")
    
    -- 如果需要点击自动战斗按钮
    if Config.AUTO_ATTACK then
        -- 点击自动战斗按钮
        local autoFightBtn = Config.coordinates.battle.autoFightButton
        tap(autoFightBtn.x, autoFightBtn.y)
        print("已启用自动战斗")
    end
    
    -- 计算剩余打怪时间
    local remainingTime = duration
    if bossHunted then
        -- 如果打过Boss，减去Boss战斗时间
        remainingTime = duration - Config.BOSS_FIGHT_TIME
        if remainingTime < 0 then remainingTime = 0 end
    end
    
    -- 不再使用一次性sleep，而是分段sleep并检测玩家
    local startTime = os.time() * 1000
    local endTime = startTime + remainingTime
    local checkInterval = Config.PLAYER_DETECTION_INTERVAL
    
    while (os.time() * 1000) < endTime do
        -- 计算下一次检测前需要等待的时间
        local waitTime = math.min(checkInterval, endTime - (os.time() * 1000))
        if waitTime <= 0 then break end
        
        -- 短暂等待
        sleep(waitTime)
        
        -- 检测是否有玩家（如果启用了该功能）
        if Config.PLAYER_DETECTION_ENABLED then
            if Battle.checkForPlayers() then
                -- 检测到玩家，执行回城操作
                Battle.returnToCity()
                print("检测到玩家，已终止打怪并回城")
                return
            end
        end
    end
    
    print(mapName .. " 打怪完成")
end

-- 检测区域内是否有玩家
function Battle.checkForPlayers()
    -- print("检测区域内是否有玩家...")
    
    local region = Config.PLAYER_DETECTION_REGION
    local x, y = -1, -1
    local ret, x, y = findPic(region[1], region[2], region[3], region[4], "player.bmp", "101010", 0, 0.9)
    
    if x ~= -1 and y ~= -1 then
		print("检测到玩家！坐标: " .. x .. ", " .. y)
        toast("检测到玩家！坐标: " .. x .. ", " .. y)
        return true
    else
        toast("未检测到玩家")
        return false
    end
end

-- 执行回城操作
function Battle.returnToCity()
    print("检测到玩家，执行回城操作...")
    
    -- 点击回城按钮
    local returnBtn = Config.coordinates.battle.returnToCityButton
    tap(returnBtn.x, returnBtn.y)
    sleep(2000)  -- 等待回城操作完成
    
    print("回城操作已执行")
    return true
end

return Battle 