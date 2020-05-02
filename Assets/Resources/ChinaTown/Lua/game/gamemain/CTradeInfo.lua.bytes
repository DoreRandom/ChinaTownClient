local o = class("CTradeInfo",CObject,CGameObjContainer)

function o.ctor(self,obj,isLocal)
    CObject.ctor(self,obj,true)
    CGameObjContainer.ctor(self,obj)

    self.m_NameText = self:GetUI(1,UIText)
    self.m_MoneyText = self:GetUI(3,UIText)
    self.m_LockText = self:GetUI(4,UIText)

    self.m_IsLocal = isLocal

    local shopGroup = self:GetTransform(2)
    self.m_ShopCards = {}
    for i=1,shopGroup.childCount do
        local t = shopGroup:GetChild(i-1)
        local go = t.gameObject

        local index = i
        
        self.m_ShopCards[i] = CShopCard.New(go,{shopId = i,
        leftClick = function () self:OnLeftClickShop(index) end,
        rightClick = function () self:OnRightClickShop(index) end})
    end    
end

function o:OnLeftClickShop(index)
    if self.m_IsLocal then
        NetBattle.C2GSTradeShop(index,1) 
    end
end 

function o:OnRightClickShop(index)
    if self.m_IsLocal then
        NetBattle.C2GSTradeShop(index,-1) 
    end
end

--[[
    显示
    args
        name
        shopList
        money
        locked
]]
function o:Show(args)
    self.m_NameText.text = args.name
    self.m_MoneyText.text = tostring(args.money)
    self.m_LockText.text = tostring(args.locked ~=0 and "是" or "否") 
    
    self:ShowShop(args.shopList)
end

--显示商店
function o:ShowShop(shopList)
    for i,v in ipairs(shopList) do
        self.m_ShopCards[i]:SetCount(v)
    end
end


return o