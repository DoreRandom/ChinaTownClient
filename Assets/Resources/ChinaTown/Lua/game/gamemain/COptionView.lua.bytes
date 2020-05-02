local o = class("COptionView",CViewBase)

o.Config = {
    PrefabPath = "ChinaTown/UI/GameMain/OptionView",
    Layer = UILayers.NormalLayer,
    Recycle = true
}

local TradeIconPath = "ChinaTown/Image/Icon/trade"
local SignalIconPath = "ChinaTown/Image/Icon/signal"

local SignalRect = {
    left = -415,
    right = 415,
    top = 360,
    bottom = -360
}

function o.ctor(self,cb)
    CViewBase.ctor(self, cb)
    self.m_PrefabPath = o.Config.PrefabPath
    self.m_Layer = o.Config.Layer
    self.m_Recycle = o.Config.Recycle

end

function o.OnCreateView(self)
    --container
    self.m_TradeBtn = self:GetUI(1,UIButton)
    self.m_SignalBtn = self:GetUI(2,UIButton)
    self.m_HideBtn = self:GetUI(3,UIButton)
    self.m_LeaveBtn = self:GetUI(4,UIButton)
    self.m_SettingBtn = self:GetUI(5,UIButton)
    self.m_HelpBtn = self:GetUI(6,UIButton)

    g_ResCtrl:LoadAsync(
        TradeIconPath,
        typeof(CS.UnityEngine.Sprite),
        function(sprite,path)
            self.m_TradeSprite = sprite
        end)

    g_ResCtrl:LoadAsync(
        SignalIconPath,
        typeof(CS.UnityEngine.Sprite),
        function(sprite,path)
            self.m_SignalSprite = sprite
        end)

    self.m_TradeBtn.onClick:AddListener(callback(self,"TradeOnClick"))
    self.m_SignalBtn.onClick:AddListener(callback(self,"SignalOnClick"))
    self.m_HideBtn.onClick:AddListener(callback(self,"HideOnClick"))
    self.m_LeaveBtn.onClick:AddListener(callback(self,"LeaveOnClick"))
    self.m_SettingBtn.onClick:AddListener(callback(self,"SettingOnClick"))
    self.m_HelpBtn.onClick:AddListener(callback(self,"HelpOnClick"))
    
end

--窗口激活后调用
function o:OnShowView()
    self:DelayCall(0,"Update")
end

--隐藏后调用
function o:OnHideView()
    self:StopDelayCall("Update")
end

function o:TradeOnClick()
    local args = {}
    args.sprite = self.m_TradeSprite
    args.data = {
        event = EventDefine.CURSOR_EVENT.Trade
    }
    local view = CCursorView:GetView()
    if view then
        view:SetCursor(args)
    end
end

function o:SignalOnClick()
    local args = {}
    args.sprite = self.m_SignalSprite
    args.data = {
        event = EventDefine.CURSOR_EVENT.Signal
    }
    local view = CCursorView:GetView()
    if view then
        view:SetCursor(args)
    end
end

function o:HideOnClick()
    --是否有交易框
    local view = CTradeView:GetView()
    if view then
        view:CloseView()
        return
    end
    --是否有派发框
    view = CSelectionView:GetView()
    if view then
        view:CloseView()
        return 
    end
    --向服务端询问是否有打开
    NetBattle.C2GSShowCacheWindow()
end

--离开游戏
function o:LeaveOnClick()
    local options = {}
    options[1] = {
        text = "确定",
        cb = function ()
            NetBattle.C2GSForceLeave()
        end
    }
    options[2] = {
        text = "取消",
        cb = function ()
            
        end
    }
    CNotifyView.Notify("提示","是否退出本局游戏",options)
end

--设置
function o:SettingOnClick()
    local view = CSettingView:GetView()
    if view then
        view:ShowSetting()
    end
end

--操作指南
function o:HelpOnClick()
    CHelpView:ShowView()
end

--[[
    收到信号
]]
function o:OnSignal(args)
    local color = g_GameCtrl:GetPlayerColor(args.pid) 
    local pos = {x=args.x,y=args.y}
    local effectArgs = ChinaTownEffect[10001]
    effectArgs.pos = pos
    effectArgs.cb = function (obj)
        local image = obj:GetComponent(UIImage)
        image.color = color
    end
    g_UIEffectCtrl:AddEffect(effectArgs)
end

function o:Update()
    local view = CCursorView:GetView()
    if view then
        local data = view:GetData()
        if data and data.event == EventDefine.CURSOR_EVENT.Signal then
            local ok,pos  = g_ViewCtrl:MouseToCanvasPosition()
            if CS.UnityEngine.Input.GetMouseButtonDown(0) then
                view:ClearData()
                if  SignalRect.left <= pos.x 
                and SignalRect.right >= pos.x 
                and SignalRect.top >= pos.y 
                and SignalRect.bottom <= pos.y
                then
                    NetBattle.C2GSSignal(pos.x,pos.y)
                end
            end
        end
    end

    if CS.UnityEngine.Input.GetKeyDown(CS.UnityEngine.KeyCode.G) then
        self:SignalOnClick()
        return true
    end
    if CS.UnityEngine.Input.GetKeyDown(CS.UnityEngine.KeyCode.S) then
        self:TradeOnClick()
        return true
    end
    if CS.UnityEngine.Input.GetKeyDown(CS.UnityEngine.KeyCode.H) then
        self:HideOnClick()
        return true
    end
    return true
end




return o