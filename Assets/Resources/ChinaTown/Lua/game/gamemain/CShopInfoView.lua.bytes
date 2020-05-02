local o = class("CShopInfoView",CViewBase)

o.Config = {
    PrefabPath = "ChinaTown/UI/GameMain/ShopInfoView",
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
    --container
    self.m_NameText = self:GetUI(1,UIText)
    self.m_DesText = self:GetUI(2,UIText)
    self.m_ShopImg = self:GetUI(3,UIImage)
    self.m_PointText = self:GetUI(4,UIText)
end

--设置店铺信息
function o:SetShopInfo(shop)
    local shopDes =  ChinaTownData.shopDes[shop]
    self.m_NameText.text = shopDes.name
    self.m_DesText.text = shopDes.des

    local point = ChinaTownData.shop[shop]
    local path = ChinaTownRes.img.shopImagePath .. shop
    g_ResCtrl:LoadImage(self.m_ShopImg,path)
    self.m_PointText.text = tostring(point)
end

return o