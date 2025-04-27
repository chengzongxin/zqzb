-- 最强战兵打怪模块

-- 导入配置
local Config = require("config")
local BossHunt = require("bosshunt")  -- 新增：导入Boss狩猎模块

-- 创建战斗模块
local Battle = {}

-- 自动战斗
function Battle:autoFight()
    print("开始自动战斗...")
    -- 先左右滑动一下，失去自动战斗状态
    swipe(210, 678, 70, 678, 200)
    sleep(800)
    swipe(210, 678, 350, 678, 200)
    sleep(800)
    -- 点击自动战斗按钮
    tap(Config.coordinates.battle.autoFightButton.x, Config.coordinates.battle.autoFightButton.y)
    sleep(1000)
end



return Battle 