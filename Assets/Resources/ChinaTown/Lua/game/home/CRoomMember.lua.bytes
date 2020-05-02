local o = class("CRoomMember",CObject,CGameObjContainer)

function o:ctor(obj)
    CObject.ctor(self,obj)
    CGameObjContainer.ctor(self,obj)

    self.m_HeadImage = self:GetUI(1,UIImage)
    self.m_NameText = self:GetUI(2,UIText)
    self.m_ReadyText = self:GetUI(3,UIText)
    self.m_KickBtn = self:GetUI(4,UIButton)
    self.m_StarGo = self:GetGameObject(5)
    self.m_BgImage = self:GetUI(6,UIImage)

    self.m_ClickKickFunc = nil
    self.m_KickBtn.onClick:AddListener(function ()
        if self.m_ClickKickFunc then
            self.m_ClickKickFunc()
        end
    end)
end

function o:SetClickKick(f)
    self.m_ClickKickFunc = f
end

--显示成员
function o:ShowMember(mem)
    local path = string.format(ChinaTownRes.img.headFormatPath,mem.head)
    g_ResCtrl:LoadImage(self.m_HeadImage,path)
    self.m_NameText.text = mem.name
    self.m_ReadyText.text = mem.ready and "已准备" or ""
    if g_RoomCtrl:IsLeader(mem.pid) then
        self.m_StarGo:SetActive(true)
    else
        self.m_StarGo:SetActive(false)
    end
    if g_RoomCtrl:LocalIsLeader() and mem.pid ~= g_AttrCtrl:GetPid() then
        self.m_KickBtn.gameObject:SetActive(true)
    else
        self.m_KickBtn.gameObject:SetActive(false)
    end
    if mem.pid == g_AttrCtrl:GetPid() then
        self.m_BgImage.color = Color.New(149/255,229/255,229/255,146/255)
    else
        self.m_BgImage.color = Color.New(255/255,229/255,229/255,146/255)
    end
end


return o