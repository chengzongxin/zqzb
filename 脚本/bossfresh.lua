-- BOSS refresh detection module for YiHuo Level 2

-- Create BOSS refresh detection module
local BossFresh = {}

-- Check if BOSS is refreshed
function BossFresh.checkBossRefreshed()
    print("Checking if BOSS is refreshed...")
    
    -- Set text recognition dictionary
    setDict(0, "1.txt") -- Dictionary needs to be in resources folder
    useDict(0)
    
    -- Recognize "refreshed" text
    local ret, x, y = findStr(0, 0, 0, 0, "已刷新", "00FF00", 0.90)
    
    if x >= 0 and y >= 0 then
        print("BOSS refresh detected at coordinates: " .. x .. ", " .. y)
        return true
    else
        print("BOSS not refreshed or cannot be recognized")
        -- 鐐瑰嚮鍏抽棴鎸夐挳
        print("Clicking close button at (1324, 125)")
        tap(1324, 125)
        sleep(1000)  -- 绛夊緟鍏抽棴鍔ㄧ敾
        return false
    end
end

-- Challenge the refreshed BOSS
function BossFresh.challengeBoss()
    print("Starting to challenge BOSS...")
    
    -- Click "Challenge Now" button
    tap(925, 761)
    sleep(3000)  -- Increased wait time to ensure map is fully loaded
    
    print("Clicked challenge BOSS, successfully entered YiHuo Level 2 map")
    return true
end

return BossFresh 