local t = {}
--初始化
function t.Init()
    t.Location2Area = {} --记录地点所在区域
    for areaId,data in ipairs(ChinaTownData.area) do
        local id = data.startIndex - 1
        for r,row in ipairs(data.map) do
            for c,isLocation in ipairs(row) do
                if isLocation == 1 then
                    id = id + 1
                    t.Location2Area[id] = areaId
                end
            end
        end
    end

    t.Area2LocationMap = {} --记录区域的地图
    for areaId,data in ipairs(ChinaTownData.area) do
        local id = data.startIndex - 1
        local map = {}
        for r,row in ipairs(data.map) do
            map[r] = {}
            for c,isLocation in ipairs(row) do
                
                if isLocation == 1 then
                    id = id + 1
                    map[r][c] = id
                else
                    map[r][c] = 0
                end
            end
        end
        t.Area2LocationMap[areaId] = map
    end

    t.Location2Pos = {} --记录地点在区域内的位置
    for areaId,data in ipairs(ChinaTownData.area) do
        local id = data.startIndex - 1
        for r,row in ipairs(data.map) do
            for c,isLocation in ipairs(row) do   
                if isLocation == 1 then
                    id = id + 1
                    local pos = {}
                    pos.r = r
                    pos.c = c
                    t.Location2Pos[id] = pos
                end
            end
        end
    end

    t.AreaRect = {} --区域的范围
    for areaId,data in ipairs(ChinaTownData.area) do
        local areaRect = {}
        areaRect.left = data.x - ChinaTownData.gridSize/2
        areaRect.top = data.y + ChinaTownData.gridSize/2
        local l = data.map[1]
        local r = #data.map
        local c = #l
        areaRect.right = areaRect.left + ChinaTownData.gridSize * c
        areaRect.bottom = areaRect.top - ChinaTownData.gridSize * r
        t.AreaRect[areaId] = areaRect
    end

    t.IsInit = true
end

--通过地点获得位置
function t.GetPositionByLocation(location)
    if not t.IsInit then
        t.Init()
    end
    local areaId = t.Location2Area[location]
    local area = ChinaTownData.area[areaId]
    local arrayPos = t.Location2Pos[location]

    local rectX = area.x + (arrayPos.c - 1) * ChinaTownData.gridSize
    local rectY = area.y - (arrayPos.r - 1) * ChinaTownData.gridSize

    return rectX,rectY
end


--通过位置获得地点
function t.GetLocationByPosition(x,y)
    if not t.IsInit then
        t.Init()
    end
    local areaId = nil 
    local areaRect = nil
    for id,rect in pairs(t.AreaRect) do
        if  rect.left < x 
            and rect.right >= x 
            and rect.top > y 
            and rect.bottom <= y
        then
            areaId = id
            areaRect = rect
            break
        end
    end
    if not areaId then
        return 0
    end
    local c = math.floor((x - areaRect.left)/ChinaTownData.gridSize) + 1
    local r = math.floor((areaRect.top - y)/ChinaTownData.gridSize) + 1
    
    return t.Area2LocationMap[areaId][r][c]
end


return t