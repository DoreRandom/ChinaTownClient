local o = class("CShopView",CViewBase)

o.Config = {
    PrefabPath = "ChinaTown/UI/GameMain/ShopView",
    Layer = UILayers.NormalLayer,
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
    local shopGroup = self:GetTransform(1)
    for i=1,shopGroup.childCount do
        local t = shopGroup:GetChild(i-1)
        local go = t.gameObject

        local index = i
        
        self.m_ShopCards[i] = CShopCard.New(go,{shopId = i,
        leftClick = function ()
            self:OnLeftClickShop(index)
        end,
        onEnter = function ()
            CShopInfoView:ShowView(function (view)
                view:SetShopInfo(index)
            end)
        end,
        onExit = function ()
            CShopInfoView:CloseView()
        end
        })
    end
end
--click
function o:OnLeftClickShop(index)
    local shopCard = self.m_ShopCards[index]
    local count = shopCard:GetCount()
    
    if g_GameCtrl:GetTid() ~= 0 then
        return
    end
    if count > 0 then
        local args = {}
        args.sprite = shopCard:GetShopSprite()
        args.data = {
            event = EventDefine.CURSOR_EVENT.PutShop,
            shop = shopCard:GetShopId()
        }
        local view = CCursorView:GetView()
        if view then
            view:SetCursor(args)
        end
    end
end

--click end

function o:OnShowView()
    local player = g_GameCtrl:GetLocalPlayer()
    self:ShowShop(player.status.shopList)

    g_GameCtrl:AddEvent(self,EventDefine.CTRL_EVENT.RefreshPlayerStatus,function (_,data)
        if player.pid ~= data.pid then
            return
        end
        local status = data.status
        if status.shopList == nil or #status.shopList == 0 then
            return 
        end
        self:ShowShop(status.shopList)
    end)
end

function o:OnHideView()
    g_GameCtrl:DelEvent(self,EventDefine.CTRL_EVENT.RefreshPlayerStatus)
end

--显示商店
function o:ShowShop(shopList)
    for i,v in ipairs(shopList) do
        self.m_ShopCards[i]:SetCount(v)
    end
end


return o