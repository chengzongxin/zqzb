-- 最强战兵打怪模块

-- 导入配置
local Config = require("config")
local BossHunt = require("bosshunt")  -- 新增：导入Boss狩猎模块

-- 创建战斗模块
local Battle = {}

-- 自动战斗
function Battle:autoFight()
    print("开始自动战斗...")
    -- 检测是否在自动战斗状态
    setDict(0,"1.txt") --字库需要放到资源文件中
    useDict(0)
    local ret,x,y = findStr(589,526,1077,718,"战","FFFFC0-0F0F0F|FFFFDD-0F0F0F|FFFFA6-0F0F0F|FFFE94-0F0F0F|EBEBAD-0F0F0F|FDFDF1-0F0F0F|FFFFD1",0.50)
    if x >=0 and y >= 0 then
        print("在自动战斗状态 "..x.." "..y)
    else
        print("不在自动战斗状态，点击自动战斗按钮")
        -- 先左右滑动一下，失去自动战斗状态
        swipe(210, 678, 70, 678, 200)
        sleep(500)
        swipe(210, 678, 350, 678, 200)
        sleep(500)
        -- 点击自动战斗按钮
        tap(Config.coordinates.battle.autoFightButton.x, Config.coordinates.battle.autoFightButton.y)
        sleep(1000)
    end
end

return Battle