-- BOSS refresh detection module for YiHuo Level 2 and Avatar Cross-Server BOSS

-- Create BOSS refresh detection module
local BossFresh = {}

-- Check if BOSS is refreshed
function BossFresh.checkBossRefreshed()
    print("Checking if BOSS is refreshed...")
    
    -- Set text recognition dictionary
    setDict(0, "1.txt") -- Dictionary needs to be in resources folder
    useDict(0)
    
    -- Get current time
    local hour = tonumber(os.date("%H"))
    local isAvatarBossTime = (hour >= 12 and hour < 14) -- 12:00-14:00
    
    if isAvatarBossTime then
        print("当前是化身跨服BOSS时间（12:00-14:00），检查化身跨服BOSS...")
        return BossFresh.checkAvatarBoss()
    else
        print("当前不是化身跨服BOSS时间，检查异火BOSS...")
        return BossFresh.checkYiHuoBoss()
    end
end

-- Check YiHuo BOSS refresh
function BossFresh.checkYiHuoBoss()
    -- Recognize "refreshed" text
    local ret, x, y = findStr(0, 0, 0, 0, "已刷新", "00FF00", 0.90)
    
    if x >= 0 and y >= 0 then
        print("异火BOSS refresh detected at coordinates: " .. x .. ", " .. y)
        return true
    else
        print("异火BOSS not refreshed or cannot be recognized")
        -- 点击关闭按钮
        print("Clicking close button at (1324, 125)")
        tap(1324, 125)
        sleep(1000)  -- 等待关闭动画
        return false
    end
end

-- Check Avatar Cross-Server BOSS refresh
function BossFresh.checkAvatarBoss()
    local Config = require("config")
    local avatarBoss = Config.coordinates.avatarBoss
    
    -- 依次检查每个楼层
    for _, floor in ipairs(avatarBoss.floors) do
        print("检查" .. floor.name .. "...")
        
        -- 点击对应楼层
        tap(floor.x, floor.y)
        sleep(1000)  -- 等待加载
        
        -- 检查是否刷新
        local ret, x, y = findStr(avatarBoss.refreshCheckRegion[1], avatarBoss.refreshCheckRegion[2],
                                 avatarBoss.refreshCheckRegion[3], avatarBoss.refreshCheckRegion[4],
                                 "已刷新", "00FF00", 0.90)
        
        if x >= 0 and y >= 0 then
            print(floor.name .. " BOSS已刷新，坐标: " .. x .. ", " .. y)
            -- 点击立即挑战
            tap(avatarBoss.challengeButton.x, avatarBoss.challengeButton.y)
            sleep(3000)  -- 等待进入地图
            return true
        else
            print(floor.name .. " BOSS未刷新")
        end
    end
    
    -- 所有楼层都未刷新，点击关闭按钮
    print("所有楼层都未刷新，点击关闭按钮")
    tap(1324, 125)
    sleep(1000)
    return false
end

-- Challenge the refreshed BOSS
function BossFresh.challengeBoss()
    print("Starting to challenge BOSS...")
    
    -- Get current time
    local hour = tonumber(os.date("%H"))
    local isAvatarBossTime = (hour >= 12 and hour < 14) -- 12:00-14:00
    
    if isAvatarBossTime then
        print("当前是化身跨服BOSS时间，已通过checkAvatarBoss进入地图")
        return true
    else
        -- 点击异火BOSS的挑战按钮
        tap(925, 761)
        sleep(3000)  -- 等待进入地图
        print("Clicked challenge BOSS, successfully entered YiHuo Level 2 map")
        return true
    end
end

return BossFresh 