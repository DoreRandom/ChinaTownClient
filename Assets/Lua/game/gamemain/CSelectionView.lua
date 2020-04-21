local o = class("CSelectionView",CViewBase)

local StartOffset = {
    [7] = -192,
    [6] = -160,
    [5] = -128,
    [4] = -96
}

o.Config = {
    PrefabPath = "ChinaTown/UI/GameMain/SelectionView",
    Layer = UILayers.InfoLayer,
    Recycle = true
}

function o.ctor(self,cb)
    CViewBase.ctor(self, cb)
    self.m_PrefabPath = o.Config.PrefabPath
    self.m_Layer = o.Config.Layer
    self.m_Recycle = o.Config.Recycle
end

function o.OnCreateView(self)
    self.m_CardParent = self:GetTransform(1)
    self.m_LocationParent = self:GetTransform(2)
    self.m_ConfirmButton = self:GetUI(3,UIButton)
    self.m_TimeText = self:GetUI(4,UIText)

    self.m_Cards = {}
    self.m_Locations = {}

    self.m_Max = self.m_CardParent.childCount
    for i=1,self.m_CardParent.childCount do
        local t = self.m_CardParent:GetChild(i-1)
        local go = t.gameObject
        local grid = CSelectionGrid.New(go,true)
        self.m_Cards[i] = grid
        grid:SetButtonClick(function ()
            self:OnCardSelected(i)
        end)
    end
    
    for i=1,self.m_LocationParent.childCount do
        local t = self.m_LocationParent:GetChild(i-1)
        local go = t.gameObject
        local grid = CSelectionGrid.New(go,false)
        self.m_Locations[i] = grid
        grid:SetButtonClick(function ()
            self:OnLocationSelected(i)
        end)
    end

    self.m_ConfirmButton.onClick:AddListener(function ()
        self:OnConfirm()
    end)
end

--[[
    args
        shopList
        locationList
]]
function o:SetSelections(args)
    self.m_ShopList = args.shopList
    self.m_LocationList = args.locationList
    self.m_CountDown = args.expTime - args.nowTime
    assert(self.m_CountDown >0,"时间不对")
    self.m_SelectedShopList = {}
    self.m_SelectedLocationList = {}
    self.m_Need = #args.shopList - 2

    local offset = StartOffset[#args.shopList]

    for i=1,self.m_Max do
        local grid = self.m_Cards[i]
        if self.m_ShopList[i] then
            grid:SetActive(true)
            grid:UnMark()
            grid:SetShop(self.m_ShopList[i])
            grid:SetOffset(offset,i)
        else
            grid:SetActive(false)
        end
    end

    for i=1,self.m_Max do
        local grid = self.m_Locations[i]
        if self.m_LocationList[i] then
            grid:SetActive(true)
            grid:UnMark()
            grid:SetLocation(self.m_LocationList[i])
            grid:SetOffset(offset,i)
        else
            grid:SetActive(false)
        end
    end

    self.m_TimeText.text = tostring(self.m_CountDown)

    self:StopDelayCall("CountDown")
    self:DelayCall(1,"CountDown")
end

--倒计时
function o:CountDown()
    self.m_CountDown = self.m_CountDown - 1
    if self.m_CountDown <= 0 then
        self.m_TimeText = 0
        return
    end
    self.m_TimeText.text = tostring(self.m_CountDown)
    return true
end

function o:OnHideView()
    self:StopDelayCall("CountDown")
end

--点击确认
function o:OnConfirm()
    if #self.m_SelectedShopList < self.m_Need then
        CNotifyView.Notify("提示",string.format("本轮 店铺 需要选择 %d 张",self.m_Need),{})
        return
    end
    if #self.m_SelectedLocationList < self.m_Need then
        CNotifyView.Notify("提示",string.format("本轮 土地 需要选择 %d 张",self.m_Need),{})
        return
    end
    
    local shopList = {}
    local locationList = {}
    
    for _,index in ipairs(self.m_SelectedShopList) do
        local shop = self.m_ShopList[index]
        table.insert(shopList,shop)
    end
    for _,index in ipairs(self.m_SelectedLocationList) do
        local location = self.m_LocationList[index]
        table.insert(locationList,location)
    end

    NetBattle.C2GSSelectCard(shopList,locationList)
end

--当卡牌被选择时
function o:OnCardSelected(index)
    local grid = self.m_Cards[index]
    for i,v in ipairs(self.m_SelectedShopList) do
        if v == index then
            grid:UnMark()
            table.remove(self.m_SelectedShopList,i)
            return 
        end
    end
    if #self.m_SelectedShopList >= self.m_Need then
        return
    end
    grid:Mark()
    self.m_SelectedShopList[#self.m_SelectedShopList+1] = index
end

--当地点被选择时
function o:OnLocationSelected(index)
    local grid = self.m_Locations[index]
    for i,v in ipairs(self.m_SelectedLocationList) do
        if v == index then
            grid:UnMark()
            table.remove(self.m_SelectedLocationList,i)
            return
        end
    end
    if #self.m_SelectedLocationList >= self.m_Need then
        return
    end
    grid:Mark()
    self.m_SelectedLocationList[#self.m_SelectedLocationList+1] = index
end

return o