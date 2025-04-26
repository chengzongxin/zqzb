-- 最强战兵红包领取模块

-- 导入配置
local Config = require("config")

-- 创建红包模块
local RedPacket = {}

-- 领取红包
function RedPacket.collect()
    print("开始领取红包...")
    
    -- 点击打怪送红包
    local coords = Config.coordinates.redPacket
    tap(coords.enterButton.x, coords.enterButton.y)
    sleep(1000)
	
    tap(coords.openTenTimes.x, coords.openTenTimes.y)
    sleep(1000)  -- 等待动画完成
    
    -- 关闭红包窗口
    tap(coords.closeButton.x, coords.closeButton.y)
    sleep(1000)
    
    print("红包领取完成")
end

return RedPacket 