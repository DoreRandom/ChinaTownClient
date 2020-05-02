local o = class("CGameView",CViewBase)

o.Config = {
    PrefabPath = "ChinaTown/UI/GameMain/GameView",
    Layer = UILayers.NormalLayer,
    Recycle = true
}

function o.ctor(self,cb)
    CViewBase.ctor(self, cb)
    self.m_PrefabPath = o.Config.PrefabPath
    self.m_Layer = o.Config.Layer
    self.m_Recycle = o.Config.Recycle
end

function o.OnCreateView(self)
    --container
    self.m_LocationContent = self:GetGameObject(1)
    self.m_LocationClone = self:GetGameObject(2)
    --data
    self.m_IdToLocation = {}
    --logic
    self:CreateMap()
end

function o:OnHideView()
    --清空原有标注
    for i,location in pairs(self.m_IdToLocation) do
        location:Reset()
    end
end

--创建地图
function o:CreateMap()
    for areaId,data in ipairs(ChinaTownData.area) do
        local id = data.startIndex - 1
        for r,row in ipairs(data.map) do
            for c,isLocation in ipairs(row) do
                if isLocation == 1 then
                    id = id + 1
                    self.m_IdToLocation[id] =  self:CreateLocation(data.x,data.y,r,c,id,areaId)
                end
                
            end
        end
    end
end


--创建土地
--[[
    x 区域起始x
    y 区域起始y
    r 在区域中的r
    c 在区域中的c
    id 编号
    areaId 区域编号
]]
function o:CreateLocation(x,y,r,c,id,areaId)
    local gameobject = CS.UnityEngine.GameObject.Instantiate(self.m_LocationClone)
    gameobject.name = id
    local location = CLocation.New(gameobject,{
        id = id,
        areaId = areaId
    })
    
    location.transform:SetParent(self.m_LocationContent.transform)
    location.rectTransform.localScale = Vector3.New(1,1,1)
    local rectX = x + (c - 1) * ChinaTownData.gridSize
    local rectY = y - (r - 1) * ChinaTownData.gridSize

    location.rectTransform.localPosition = Vector3.New(rectX,rectY)

    location:SetActive(true)
    
    return location
end

--给区域设置属主
function o:SetLocationOwnerColor(id,color)
    local location = self.m_IdToLocation[id]
    assert(location,string.format("区域 id %d 不存在",id))
    location:SetOwnerColor(color)
end

--给区域设置店铺
function o:SetLocationShop(id,shop)
    local location = self.m_IdToLocation[id]
    assert(location,string.format("区域 id %d 不存在",id))
    location:SetShop(shop)
end
--更新区域
function o:RefreshLocation(data)
    local locations = data.locations
    for _,location in ipairs(locations) do
        local pid = rawget(location,"pid")
        local shop = rawget(location,"shop")
        local lid = rawget(location,"lid")
        if pid ~= nil then
            local color =  g_GameCtrl:GetPlayerColor(pid)
            self:SetLocationOwnerColor(lid,color)
        end
    
        --if shop ~= nil then
            self:SetLocationShop(lid,shop)
        --end
    end
end


return o