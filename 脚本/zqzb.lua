-- 最强战兵自动打怪脚本
print("最强战兵脚本启动")
toast("最强战兵启动" , 0 , 0 , 12)

-- 导入坐标识别工具
local CoordinateReader = require("coordinate_reader")
local reader = CoordinateReader

-- 测试坐标识别
while true do
	local x, y = reader:getCurrentCoordinate()
	if x and y then
		print("当前坐标: X=" .. x .. ", Y=" .. y)
	else
		print("坐标识别失败")
	end
	sleep(1000)  -- 每秒识别一次
end

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
