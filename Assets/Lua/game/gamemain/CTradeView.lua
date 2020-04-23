local o = class("CTradeView",CViewBase)

o.Config = {
    PrefabPath = "ChinaTown/UI/GameMain/TradeView",
    Layer = UILayers.InfoLayer,
    Recycle = true
}

function o.ctor(self,cb)
    CViewBase.ctor(self, cb)
        self.m_PrefabPath = o.Config.PrefabPath
    self.m_Layer = o.Config.Layer
    self.m_Recycle = o.Config.Recycle

    self.m_Flags = {}
    self.m_ShopCards = {}
end

function o.OnCreateView(self)
    --container
    self.m_FlagParent = self:GetTransform(1)
    self.m_FlagPrefab = self:GetGameObject(2)

    local otherObj = self:GetGameObject(4)
    local myObj = self:GetGameObject(5)

    self.m_TradeInfos = {
        CTradeInfo.New(myObj,true),
        CTradeInfo.New(otherObj,false)
    }

    self.m_MoneyText = self:GetUI(6,UIText)
    self.m_MoneyInput = self:GetUI(7,UIInputField)
    self.m_GiveMoneyBtn = self:GetUI(8,UIButton)
    self.m_LockBtn = self:GetUI(9,UIButton)
    self.m_LockText = self.m_LockBtn.transform:GetComponentInChildren(UIText)
    self.m_CancelTradeBtn = self:GetUI(10,UIButton)

    self.m_GiveMoneyBtn.onClick:AddListener(function ()
        self:OnClickGiveMoney()
    end)

    self.m_LockBtn.onClick:AddListener(function ()
        self:OnClickLock()
    end)

    self.m_CancelTradeBtn.onClick:AddListener(function ()
        self:OnClickCancelTrade()
    end)
end

--窗口激活后调用
function o:OnShowView()
    self:DelayCall(0,"Update")
    self.m_MoneyInput.text = "0"
end

--隐藏后调用
function o:OnHideView()
    self:StopDelayCall("Update")
    self:CloseAll()
end


--创建标识
function o:MakeFlag(location)
    if location == 0 then
        return
    end
    local flag = self.m_Flags[location]
    if flag then
        return 
    end
    local color = Color.New(1,1,1,1)
    local x,y = ChinaTownTool.GetPositionByLocation(location)
    local tradeFlag = CTradeFlag:ReuseOrCreate(self.m_FlagPrefab,self.m_FlagParent)
    tradeFlag:Show(x,y,color)
    self.m_Flags[location] = tradeFlag
end

--取消标识
function o:CancelFlag(location)
    local flag = self.m_Flags[location]
    if flag then
        flag:Recycle()
        self.m_Flags[location] = nil
    end
end

--点击给予金钱
function o:OnClickGiveMoney()
    local n = tonumber(self.m_MoneyInput.text)
    if n then
        
        NetBattle.C2GSTradeMoney(math.floor(n))   
    end
end

--点击加锁
function o:OnClickLock()
    NetBattle.C2GSTradeLock()
end

--点击取消
function o:OnClickCancelTrade()
    NetBattle.C2GSCancelTrade()
end

--隐藏
function o:CloseAll()
    for _,v in pairs(self.m_Flags) do
        v:Recycle()
    end
    self.m_Flags = {}
end

function o:Update()
    
    if CS.UnityEngine.Input.GetMouseButtonDown(0) or CS.UnityEngine.Input.GetMouseButtonDown(1) then
        local ok,pos = g_ViewCtrl:MouseToCanvasPosition()
        local location = ChinaTownTool.GetLocationByPosition(pos.x,pos.y)
        if location == 0 then
            return true
        end
        NetBattle.C2GSTradeLocation(location)
    end  
    return true
end

--设置trade
function o:SetTrade(args)

    self.m_TradeData = {}
    self.m_Tid = args.tid

    for i=1,2 do
        local tradeInfo = args.tradeInfos[i]
        local pid = tradeInfo.pid
        local player = g_GameCtrl:GetPlayer(pid)
        
        if g_GameCtrl:IsLocal(pid) then
            tradeInfo.name = "我"
        else
            tradeInfo.name = player:GetName()
        end

        self.m_TradeData[pid] = tradeInfo
    end
    self:CloseAll()
    self:ShowTrade()
end

--显示trade
function o:ShowTrade()
    local flagsCopy = table.copy(self.m_Flags) --如果不在要显示的列表中，需要移除
    for pid,tradeInfo in pairs(self.m_TradeData) do
        local tradeInfoView = nil
        if g_GameCtrl:IsLocal(pid) then
            tradeInfoView = self.m_TradeInfos[1]
            if tradeInfo.locked == 0 then
                self.m_LockText.text = "锁定"
            else
                self.m_LockText.text = "解锁"
            end
        else
            tradeInfoView = self.m_TradeInfos[2]
        end
        tradeInfoView:Show(tradeInfo)

        for _,lid in ipairs(tradeInfo.locationList) do
            self:MakeFlag(lid)
            flagsCopy[lid] = nil 
        end
    end

    for lid,_ in pairs(flagsCopy) do
        self:CancelFlag(lid)
    end
end

--刷新trade信息
function o:RefreshTradeInfo(data)
    assert(data.tid == self.m_Tid,"交易id不一致")
    local tradeInfoUpdate = data.tradeInfo
    local tradeInfo = self.m_TradeData[tradeInfoUpdate.pid]
    for k,v in pairs(tradeInfoUpdate) do
        tradeInfo[k] = v
    end

    self:ShowTrade()
end

return o