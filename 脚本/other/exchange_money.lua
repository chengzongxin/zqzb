local ExchangeMoney = {}

-- 构造函数
function ExchangeMoney:new()
	local o = {}
	setmetatable(o , {__index = ExchangeMoney})
	return o
end

function ExchangeMoney:getBox()
	while true do
		tap(456 , 665)
		sleep(100)
	end
end

function ExchangeMoney:exchange()
	-- 点击背包
	print("点击背包")
	tap(1086 , 781)
	sleep(500)
	-- 点击元宝
	for i = 1 , 40 , 1 do
		print("点击元宝")
		tap(103 , 195)
		sleep(200)
	end
	-- 点击关闭背包
	print("点击关闭背包")
	tap(803 , 114)
	sleep(500)
	-- 点击使者
	print("点击使者")
	tap(941 , 402)
	sleep(500)
	-- 点击兑换
	for i = 1 , 80 , 1 do
		print("点击兑换")
		tap(710 , 429)
		sleep(200)
	end
	-- 点击关闭
	print("点击关闭")
	tap(1323 , 128)
	sleep(500)
	
end

function ExchangeMoney:start()
	-- 人物坐标要走到340：323
	while true do
		self:exchange()
	end
end

return ExchangeMoney
