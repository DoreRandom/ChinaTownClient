local o = class("CLookShopView",CViewBase)

o.Config = {
    PrefabPath = "ChinaTown/UI/GameMain/LookShopView",
    Layer = UILayers.InfoLayer,
    Recycle = true
}

function o.ctor(self,cb)
    CViewBase.ctor(self, cb)
        self.m_PrefabPath = o.Config.PrefabPath
    self.m_Layer = o.Config.Layer
    self.m_Recycle = o.Config.Recycle

    self.m_ShopCards = {}
end

function o.OnCreateView(self)
    --container
    self.m_NameText = self:GetUI(1,UIText)
    local shopGroup = self:GetTransform(2)
    for i=1,shopGroup.childCount do
        local t = shopGroup:GetChild(i-1)
        local go = t.gameObject
        self.m_ShopCards[i] = CShopCard.New(go,{shopId = i})
    end
end

function o:ShowShop(name,shopList)
    self.m_NameText.text = name
    for i,v in ipairs(shopList) do
        self.m_ShopCards[i]:SetCount(v)
    end
end


return o