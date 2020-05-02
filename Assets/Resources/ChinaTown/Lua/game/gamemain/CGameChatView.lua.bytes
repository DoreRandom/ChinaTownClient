local o = class("CGameChatView",CViewBase)

o.Config = {
    PrefabPath = "ChinaTown/UI/GameMain/GameChatView",
    Layer = UILayers.NormalLayer,
    Recycle = true
}

local ChatPos = {
    {x=260,y=-280},
    {x=260,y=280},
    {x=260,y=150},
    {x=260,y=20},
    {x=260,y=-110},
}

function o.ctor(self,cb)
    CViewBase.ctor(self, cb)
    self.m_PrefabPath = o.Config.PrefabPath
    self.m_Layer = o.Config.Layer
    self.m_Recycle = o.Config.Recycle

    self.m_ChatBoxs = {}
end

function o.OnCreateView(self)
    self.m_ChatInput = self:GetUI(1,UIInputField)
    self.m_ChatBtn = self:GetUI(2,UIButton)
    self.m_ChatBoxParent = self:GetTransform(3)
    self.m_ChatBoxPrefab = self:GetGameObject(4)

    self.m_ChatBtn.onClick:AddListener(function ()
        self:OnClickChat()
    end)
end

--聊天
function o:OnClickChat()
    local str = self.m_ChatInput.text
    if string.len(str) == 0 then
        return
    end
    if string.len(str) > 50 then
        CNotifyView.Notify("提示","聊天字节数不能大于 50 ",{})
        return
    end

    self.m_ChatInput.text = ""

    NetChat.C2GSChat(BROADCAST_TYPE.ROOM_TYPE,str)
end

--窗口激活后调用
function o:OnShowView()
    self:DelayCall(0,"Update")
    g_ChatCtrl:AddEvent(self,EventDefine.CTRL_EVENT.RoomMsg,function (_,data)
        self:AddChatMsg(data)        
    end)
end

--隐藏后调用
function o:OnHideView()
    self:StopDelayCall("Update")
    self:CloseAll()
    g_ChatCtrl:DelEvent(self,EventDefine.CTRL_EVENT.RoomMsg)
end

--[[
    消息
    args
        pid
        msg
]]
function o:AddChatMsg(args)
    local index = g_GameCtrl:GetPlayerIndex(args.pid)
    if not index then
        return
    end
    local pos = ChatPos[index]
    local chatbox = CChatBox:ReuseOrCreate(self.m_ChatBoxPrefab,self.m_ChatBoxParent)
    chatbox:Show(args.msg,pos)
    self.m_ChatBoxs[chatbox:GetID()] = chatbox
end

--关闭所有
function o:CloseAll()
    for _,chatbox in pairs(self.m_ChatBoxs) do
        chatbox:Recycle()
    end
    self.m_ChatBoxs = {}
end

function o:Update()
    for id,chatbox in pairs(self.m_ChatBoxs) do
        if chatbox:GetOver() then
            chatbox:Recycle()
            self.m_ChatBoxs[id] = nil
        end
    end
    return true
end


return o