local o = class("CJoinRoomView",CViewBase)

o.Config = {
    PrefabPath = "ChinaTown/UI/Home/JoinRoomView",
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
    self.m_RoomIdInput = self:GetUI(1,UIInputField)
    self.m_JoinBtn = self:GetUI(2,UIButton)
    self.m_CancelBtn = self:GetUI(3,UIButton)

    self.m_JoinBtn.onClick:AddListener(function ()
        self:OnClickJoin()
    end)
    self.m_CancelBtn.onClick:AddListener(function ()
        self:OnClickCancel()
    end)
end

function o:OnClickJoin()
    local roomId = tonumber(self.m_RoomIdInput.text)
    if roomId and roomId > 0 then
        NetRoom.C2GSJoinRoom(roomId)
    else
        CNotifyView.Notify("","房间id无效")
    end
end

function o:OnClickCancel()
    self:CloseView()
end

return o