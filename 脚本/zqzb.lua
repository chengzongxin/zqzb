-- 最强战兵自动打怪脚本
print("最强战兵脚本启动")
toast("最强战兵启动", 0, 0, 12)

-- 导入模块
local Config = require("config")
local GameManager = require("game_manager")
local GlobalMonitor = require("global_monitor")

-- 创建游戏管理器实例
local gameManager = GameManager:new()

-- 初始化UI
local ret = getUIConfig("main.config")
if ret then
	gameManager:updateConfig(ret)
end

-- 启动游戏
gameManager:run()
