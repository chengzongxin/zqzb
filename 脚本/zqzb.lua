-- 最强战兵自动打怪脚本
print("最强战兵脚本启动")
toast("最强战兵启动" , 0 , 0 , 12)

function onUIEvent(handle , event , arg1 , arg2 , arg3)
	if event == "onload" then
		print("窗口被加载了")
	elseif event == "onclick" then
		print("按钮点击事件:" , arg1 , arg2)
		keyPress("home")
	elseif event == "onchecked" then
		print("多选框选中或反选事件:" , arg1 , arg2)
	elseif event == "onselected" then
		print("单选框或者下拉框事件:" , arg1 , arg2)
	elseif event == "onclose" then
		print("关闭窗口" , arg1)
		closeWindow(handle , arg1)
	elseif event == "onwebviewjsevent" then
		print("webview事件" , arg1 , arg2 , arg3)
	end
end

-- local ret = showUI("zqzb.ui",-1,-1,onUIEvent)
local ret = getUIConfig("main.config")

print(ret)

-- 导入模块
local Config = require("config")
local Battle = require("battle")
local RedPacket = require("redpacket")

-- 解析UI配置并更新Config对象
function updateConfigFromUI(uiConfig)
	if type(uiConfig) == "string" then
		-- 如果是字符串，尝试解析为JSON
		uiConfig = jsonLib.decode(uiConfig)
	end
	
	-- 检查配置是否有效
	if type(uiConfig) ~= "table" or not uiConfig.page0 then
		print("UI配置无效或为空，使用默认配置")
		return
	end
	
	local page0 = uiConfig.page0
	
	-- 更新每个地图的挂机时间
	for i = 1 , #Config.maps do
		local mapTimeKey = "mapTime_" .. i
		if page0[mapTimeKey] then
			local minutes = tonumber(page0[mapTimeKey]) or
			(i <= 3 and 10 or 5) -- 特殊地图默认10分钟，十六大陆默认5分钟
			Config.maps[i].fightTime = minutes * 60 * 1000
			print("已设置 " .. Config.maps[i].name .. " 挂机时间: " .. minutes .. "分钟")
		end
	end
	
	-- 更新是否只打boss
	if page0.idBossOnly then
		local onlyBoss = page0.idBossOnly == "true"
		Config.BOSS_HUNT_ENABLED = onlyBoss
		Config.ONLY_BOSS_MODE = onlyBoss -- 使用相同的设置更新ONLY_BOSS_MODE
		print("是否只打boss: " .. tostring(onlyBoss))
	end
	
	-- 更新是否启用自动战斗
	if page0.idAutoEnabled then
		local autoEnabled = page0.idAutoEnabled == "true"
		Config.AUTO_ATTACK = autoEnabled
		print("是否启用自动战斗: " .. tostring(autoEnabled))
	end
	
	-- 更新是否启用玩家检测
	if page0.idPlayerDetection then
		local playerDetection = page0.idPlayerDetection == "true"
		Config.PLAYER_DETECTION_ENABLED = playerDetection
		print("是否检测玩家自动回城: " .. tostring(playerDetection))
	end
	
	-- 更新起始地图
	if page0.idStartMap then
		local mapIndex = tonumber(page0.idStartMap) + 1 -- 下拉框索引从0开始
		current_map = mapIndex
		print("设置起始地图为: " .. Config.maps[mapIndex].name)
	end
end

-- 更新配置
updateConfigFromUI(ret)

-- 检查并切换到玩家列表模式
function checkAndSwitchToPlayerListMode()
	print("检查是否已切换到玩家列表模式...")
	local region = Config.PLAYER_DETECTION_SWICH_PLAYER_REGION
	local index = - 1
	local ret = nil
	index , ret = findPicFast(region[1], region[2], region[3], region[4], "人物.png" , "000000" , 0 , 0.9)
	print("检测结果:" , index , ret)
	
	if index == - 1 then
		-- 未找到人物.png，说明不在玩家列表模式，需要切换
		print("未处于玩家列表模式，正在切换...")
		tap(27 , 272)
		sleep(1000) -- 等待切换完成
		
		-- 再次检查是否成功切换
		index , ret = findPicFast(region[1], region[2], region[3], region[4], "人物.png" , "000000" , 0 , 0.9)
		if index ~= - 1 then
			print("成功切换到玩家列表模式")
		else
			print("警告：切换到玩家列表模式失败，可能影响脚本运行")
		end
	else
		print("已处于玩家列表模式，无需切换")
	end
end

-- ==================== 主循环 ====================
local current_map = 1
local lastRedPacketTime = 0 -- 上次领红包的时间
local lastPlayerCheckTime = 0 -- 上次检测玩家的时间

function checkPlayer()
	if Battle.checkForPlayers() then
		-- 检测到玩家，执行回城操作
		Battle.returnToCity()
		-- 切换到下一个地图
		current_map = current_map % #Config.maps + 1
		print("检测到玩家，已回城，准备切换到下一个地图: " .. Config.maps[current_map].name)
		-- 继续下一次循环
		sleep(1000) -- 给回城一些时间
	end
end

-- 在地图切换前检测是否还有Boss
function checkForRemainingBoss(map)
	print("检测 " .. map.name .. " 是否还有未击杀的Boss...")
	
	-- 最大检测次数，防止无限循环
	local maxAttempts = 3
	local attempts = 0
	
	-- 引入BossHunt模块
	local BossHunt = require("bosshunt")
	
	while attempts < maxAttempts do
		attempts = attempts + 1
		print("第 " .. attempts .. " 次检测Boss...")
		
		-- 尝试寻找并击杀Boss
		local bossFound = BossHunt.huntBoss()
		
		if bossFound then
			print("发现Boss并已尝试击杀，将继续在当前地图打怪")
			-- 继续执行一轮打怪
			Battle.fightInMap(map.name, map, Config.FIGHT_TIME)
		else
			print("未发现Boss，可以安全切换到下一个地图")
			return false
		end
		
		-- 检测玩家
		if Config.PLAYER_DETECTION_ENABLED then
			if Battle.checkForPlayers() then
				print("检测到玩家，终止Boss检测并准备切换地图")
				Battle.returnToCity()
				return false
			end
		end
	end
	
	print("达到最大检测次数 " .. maxAttempts .. "，将切换到下一个地图")
	return false
end

-- 检测并关闭任何弹窗（简化版）
function checkAndClosePopup()
	print("检测是否有弹窗...")
	local ret, x, y = findPic(0, 0, 0, 0, "关闭.png", "101010", 0, 0.7)
	print("弹窗检测结果:", ret, x, y)
	
	if ret ~= -1 then
		print("检测到弹窗，位置: x=" .. x .. ", y=" .. y)
		
		-- 点击关闭按钮
		tap(x, y)
		print("已点击关闭按钮")
		sleep(500) -- 给关闭动画一些时间
		return true
	else
		print("未检测到弹窗")
		return false
	end
end

function startGame()
	-- 进入游戏主循环
	while true do
		-- 前往当前地图并打怪
		local map = Battle.gotoMap(current_map)
		if not map then
			-- 如果无法进入当前地图（例如BOSS未刷新）
			print("无法进入当前地图，切换到下一个")
			current_map = current_map % #Config.maps + 1
			goto continue -- 跳过当前循环，尝试下一个地图
		end
		
		-- 当前时间，用于各种检测
		local currentTime = os.time() * 1000
		
		-- 检测玩家（如果启用了该功能）
		checkPlayer()
		
		-- 继续正常的打怪流程
		Battle.fightInMap(map.name, map, Config.FIGHT_TIME)
		
		-- 在切换地图前检测是否还有Boss
		if Config.BOSS_HUNT_ENABLED then
			checkForRemainingBoss(map)
		end
		
		-- 切换地图前再次检测并关闭弹窗
		checkAndClosePopup()
		
		-- 切换到下一个地图
		current_map = current_map % #Config.maps + 1
		print("打怪时间结束，准备切换到下一个地图: " .. Config.maps[current_map].name)
		
		-- 检查是否需要领红包
		if (currentTime - lastRedPacketTime) >= Config.COLLECT_REDPACKET_INTERVAL then
			RedPacket.collect()
			lastRedPacketTime = currentTime
		else
			print("下次领红包时间", currentTime - lastRedPacketTime)
		end
		
		-- 暂停一下，防止操作过快
		sleep(1000)
		
		::continue:: -- 这是一个循环标签，用于goto语句
	end
end

function main()

	-- 检测并关闭任何弹窗
	checkAndClosePopup()
	
	-- 执行模式检查
	checkAndSwitchToPlayerListMode()
	
	-- 开始游戏
	startGame()
	
end

main()
