local o = class("CRoomView",CViewBase)

o.Config = {
    PrefabPath = "ChinaTown/UI/Home/RoomView",
    Layer = UILayers.NormalLayer,
    Recycle = true
}

function o.ctor(self,cb)
    CViewBase.ctor(self, cb)
    self.m_PrefabPath = o.Config.PrefabPath
    self.m_Layer = o.Config.Layer
    self.m_Recycle = o.Config.Recycle

    self.m_RoomMembers = {}
end

function o.OnCreateView(self)
    --container
    self.m_GameBtn = self:GetUI(1,UIButton)
    self.m_GameBtnText = self:GetUI(2,UIText)
    self.m_LeaveBtn = self:GetUI(3,UIButton)
    self.m_RoomIdText = self:GetUI(4,UIText)
    self.m_MemberGroup = self:GetTransform(5)

    for i=0,self.m_MemberGroup.childCount-1 do
        local trans = self.m_MemberGroup:GetChild(i)
        local go = trans.gameObject
        local roomMember = CRoomMember.New(go)
        local pos = i + 1
        roomMember:SetClickKick(function ()
            self:OnClickKick(pos)
        end)
        self.m_RoomMembers[pos] = roomMember
        roomMember:SetActive(false)
    end

    self.m_GameBtn.onClick:AddListener(function ()
        self:OnClickGame()
    end)
    self.m_LeaveBtn.onClick:AddListener(function ()
        self:OnClickLeave()
    end)

end

--click
function o:OnClickGame()
    local mem = g_RoomCtrl:GetMemberByPid(g_AttrCtrl:GetPid())
    if g_RoomCtrl:LocalIsLeader() then
        NetRoom.C2GSStartGame()
    else
        NetRoom.C2GSSetReady(not mem.ready)
    end
end

function o:OnClickLeave()
    NetRoom.C2GSLeaveRoom()
end

function o:OnClickKick(i)
    local mem = g_RoomCtrl:GetMember(i)
    if mem then
        if g_RoomCtrl:LocalIsLeader() and g_AttrCtrl:GetPid() ~= mem.pid then
            NetRoom.C2GSKickRoom(mem.pid)
        else
            print("RoomView:OnClickKick show error")
        end
    else
        print("RoomView:OnClickKick %s error",i)
    end
end

--data
function o:Show()
    local members = g_RoomCtrl:GetMembers()
    for i=1,#self.m_RoomMembers do
        local mem = members[i]
        local memView = self.m_RoomMembers[i]
        if mem then
            memView:ShowMember(mem)
            memView:SetActive(true)
        else
            memView:SetActive(false)
        end
    end

    self.m_RoomIdText.text = string.format("ID:%s",g_RoomCtrl:GetRoomId())

    local mem = g_RoomCtrl:GetMemberByPid(g_AttrCtrl:GetPid())
    if g_RoomCtrl:LocalIsLeader() then
        self.m_GameBtnText.text = "开始游戏"
    else
        self.m_GameBtnText.text = mem.ready and "取消" or "准备"
    end
end

return o