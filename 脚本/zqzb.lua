-- 最强战兵自动打怪脚本
print("最强战兵脚本启动")
toast("最强战兵启动", 0, 0, 12)

local ExchangeMoney = require("other/exchange_money")
local exchangeMoney = ExchangeMoney:new()  -- 创建实例
--exchangeMoney:start()  -- 调用实例方法


-- 导入模块
local Config = require("config")
local GameManager = require("game_manager")

-- 创建游戏管理器实例
local gameManager = GameManager:new()

-- 初始化UI
local ret = getUIConfig("main.config")
if ret then
	gameManager:updateConfig(ret)
end

-- 启动游戏
gameManager:run()
