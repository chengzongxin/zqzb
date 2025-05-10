-- 最强战兵自动打怪脚本
print("最强战兵脚本启动")
toast("最强战兵启动" , 0 , 0 , 12)

-- -- 导入坐标识别工具
-- local CoordinateReader = require("coordinate_reader")
-- local reader = CoordinateReader

-- -- 导入寻路工具
-- local PathFinder = require("path_finder")
-- local pathFinder = PathFinder

-- -- 测试寻路功能
-- local targetX = 157  -- 目标X坐标
-- local targetY = 58   -- 目标Y坐标

-- print("开始寻路测试...")
-- toast("开始寻路到: " .. targetX .. ":" .. targetY, 0, 0, 12)
-- pathFinder:moveToTarget(targetX, targetY)

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
