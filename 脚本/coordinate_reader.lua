-- 坐标识别工具
local CoordinateReader = {}

-- 初始化字库
function CoordinateReader:initDict()
    print("正在初始化字库...")
    setDict(0, "坐标字库.txt")
    useDict(0)
    print("字库初始化完成")
end

-- 识别单个数字
function CoordinateReader:recognizeDigit(x, y)
    print("尝试识别数字，位置: x=" .. x-2 .. ", y=" .. y .. " 范围: " .. x + 12 .. ", " .. y + 20)
    
    -- 逐个尝试识别每个数字
    local digits = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"}
    for _, digit in ipairs(digits) do
        local sim = digit == "4" and 0.80 or 0.70
        local ret, _, _ = findStr(x-2, y, x + 12, y + 20, digit, "F9F8F7-080808", sim)
        if ret ~= -1 then
            print("识别到数字: " .. digit)
            return digit
        end
    end
    
    print("未识别到任何数字")
    return nil
end

-- 识别坐标
function CoordinateReader:getCurrentCoordinate()
    -- 初始化字库
    self:initDict()
    
    -- 搜索分号位置
    print("开始搜索分号位置...")
    local ret, colonX, colonY = findStr(1409, 176, 1597, 224, ":", "F9F8F7-080808", 0.70)
    print("分号搜索结果: ret=" .. tostring(ret) .. ", x=" .. tostring(colonX) .. ", y=" .. tostring(colonY))
    
    if colonX < 0 or colonY < 0 then
        print("未找到坐标分隔符")
        return nil, nil
    end
    
    -- 识别X坐标（分号左边）
    print("开始识别X坐标...")
    local x = ""
    local currentX = colonX - 3 - 10  -- 减去间隔
    print("X坐标起始位置: " .. currentX)
    
    -- 最多识别3位数字
    for i = 1, 3 do
        local digit = self:recognizeDigit(currentX - (i-1)*10, 200)
        if digit then
            x = digit .. x
            print("X坐标第" .. i .. "位: " .. digit)
        else
            print("X坐标第" .. i .. "位识别失败")
            break
        end
    end
    
    -- 识别Y坐标（分号右边）
    print("开始识别Y坐标...")
    local y = ""
    local currentY = colonX + 3  -- 加上间隔
    print("Y坐标起始位置: " .. currentY)
    
    -- 最多识别3位数字
    for i = 1, 3 do
        local digit = self:recognizeDigit(currentY + (i-1)*10, 200)
        if digit then
            y = y .. digit
            print("Y坐标第" .. i .. "位: " .. digit)
        else
            print("Y坐标第" .. i .. "位识别失败")
            break
        end
    end
    
    -- 转换为数字
    local xNum = tonumber(x)
    local yNum = tonumber(y)
    
    print("最终识别结果: X=" .. tostring(xNum) .. ", Y=" .. tostring(yNum))
    
    if xNum and yNum then
        print("坐标识别成功")
        toast("当前坐标: " .. xNum .. ":" .. yNum, 0, 0, 12)
        return xNum, yNum
    else
        print("坐标识别失败")
        toast("坐标识别失败", 0, 0, 12)
        return nil, nil
    end
end

return CoordinateReader 