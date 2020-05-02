local o = class("CPlayerInfo",CObject,CGameObjContainer)

--[[
    id 玩家id
    color 颜色
    name 名字
    headId 头像 
    curMoney 当前钱数
    lastMoney 去年营收
    shopList 店铺 这里也可以只传数量，差别不大
]]
function o.ctor(self, obj)
    CObject.ctor(self,obj,true)
    CGameObjContainer.ctor(self,obj)    

    self.m_ColorImage = self:GetUI(1,UIImage)
    self.m_HeadImage = self:GetUI(2,UIImage)
    self.m_NameText = self:GetUI(3,UIText)
    self.m_CurMoneyText = self:GetUI(4,UIText)
    self.m_LastMoneyText = self:GetUI(5,UIText)
    self.m_ShopCountText = self:GetUI(6,UIText)
    self.m_ShopEventHandler = self:GetUI(7,typeof(CS.UIEventHandler))
    self.m_TradingRect = self:GetUI(8,UIRectTransform)

    self.m_HeadBtn =self:GetUI(1,UIButton)

    self.m_HeadBtn.onClick:AddListener(function ()
        self:OnClickHead()
    end)
    self:AddShopEvent()
end

function o:OnHideView()
    self:StopDelayCall("Trading")
end

--获得pid
function o:GetPid()
    return self.m_Pid
end
--给店铺区域添加事件
function o:AddShopEvent()
    local onEnter = function (pointData)
        if self.m_ShopList then
            g_ViewCtrl:ShowView(CLookShopView,function (obj)
                obj:ShowShop(self.m_Name,self.m_ShopList)
            end)
        end
    end
    local onExit = function (pointData)
        if self.m_ShopList then
            g_ViewCtrl:CloseView(CLookShopView)
        end
    end
    self.m_ShopEventHandler.onEnter = onEnter
    self.m_ShopEventHandler.onExit = onExit
end
--点击头像按钮
function o:OnClickHead()
    local view = CCursorView:GetView()
    if view  then
        local data = view:GetData()
        if data and data.event == EventDefine.CURSOR_EVENT.Trade then
            view:ClearData()
            --不是本地玩家
            if not g_GameCtrl:IsLocal(self.m_Pid) then
                NetBattle.C2GSTrade(self.m_Pid)
            end
        end
    end
end

--获得店铺的数量
function o:GetShopCount(shopList)
    local count = 0
    for _,v in pairs(shopList) do
        count = count + v
    end
    return count
end

--设置玩家信息
function o:SetPlayerInfo(player)
    local status = player.status
    local money,lastMoney,shopList,tid = status.money,status.lastMoney,status.shopList,status.tid

    self.m_Pid = player.pid --玩家id
    self.m_Name = player:GetName() 
    self.m_ShopList = shopList

    self.m_ColorImage.color = Color.ParseHtmlString(player.color)

    local path = string.format(ChinaTownRes.img.headFormatPath,player.head)
    g_ResCtrl:LoadImage(self.m_HeadImage,path)

    self.m_NameText.text = player:GetName()
    self.m_CurMoneyText.text = tostring(money)
    self.m_LastMoneyText.text = tostring(lastMoney)
    self.m_ShopCountText.text = tostring(self:GetShopCount(shopList))

    if tid == 0 then
        self.m_TradingRect.gameObject:SetActive(false)
        self:StopDelayCall("Trading")
    else
        self.m_TradingRect.gameObject:SetActive(true)
        self:DelayCallNotReplace(0.1,"Trading")
    end
end

--交易
function o:Trading()
    if self:GetUI(8,UIRectTransform) then
        self.m_TradingRect:Rotate(0,0,-10)
    end
    return true
end

return o