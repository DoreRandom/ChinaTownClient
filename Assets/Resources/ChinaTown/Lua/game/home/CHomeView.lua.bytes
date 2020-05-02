local o = class("CHomeView",CViewBase)

o.Config = {
    PrefabPath = "ChinaTown/UI/Home/HomeView",
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
    self.m_HeadImage = self:GetUI(1,UIImage)
    self.m_NameText = self:GetUI(2,UIText)
    self.m_ScoreText = self:GetUI(3,UIText)
    self.m_HeadBtn = self:GetUI(4,UIButton)
    self.m_CreateBtn = self:GetUI(5,UIButton)
    self.m_JoinBtn = self:GetUI(6,UIButton)
    self.m_SwitchBtn = self:GetUI(7,UIButton)

    self.m_HeadBtn.onClick:AddListener(function ()
        self:OnClickHead()
    end)
    self.m_CreateBtn.onClick:AddListener(function ()
        self:OnClickCreate()
    end)
    self.m_JoinBtn.onClick:AddListener(function ()
        self:OnClickJoin()
    end)
    self.m_SwitchBtn.onClick:AddListener(function ()
        self:OnClickSwitch()
    end)

end

function o:OnShowView()
    g_AttrCtrl:AddEvent(self,EventDefine.CTRL_EVENT.SetPlayerInfo,function (_,data)
        self:SetPlayerInfo(data)
    end)
    self:SetPlayerInfo(g_AttrCtrl:GetPlayerInfo())
end

function o:OnHideView()
    g_AttrCtrl:DelEvent(self,EventDefine.CTRL_EVENT.SetPlayerInfo)
end

--click
function o:OnClickHead()
    --TODO 更换头像
end

function o:OnClickCreate()
    NetRoom.C2GSCreateRoom()
end

function o:OnClickJoin()
    CJoinRoomView:ShowView()
end

function o:OnClickSwitch()
    g_SceneCtrl:SwitchScene(SLogin)
end

--data
--[[
    eventType
    args
        headId
        name
        score
]]
function o:SetPlayerInfo(args)
    local path = string.format(ChinaTownRes.img.headFormatPath,args.head)
    g_ResCtrl:LoadImage(self.m_HeadImage,path)

    self.m_NameText.text = args.name
    self.m_ScoreText.text = tostring(args.score)
end

return o