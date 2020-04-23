local o = class("CPlayerInfo",CViewBase)

o.Config = {
    PrefabPath = "ChinaTown/UI/GameMain/PlayerInfoView",
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
    self.m_PlayerInfos = {}
    for i=1,5 do
        local go = self:GetGameObject(i)
        self.m_PlayerInfos[i] = CPlayerInfo.New(go)
    end
end

function o:OnShowView()
    local players =  g_GameCtrl:GetPlayers()
    self:SetPlayerInfo(players)

    g_GameCtrl:AddEvent(self,EventDefine.CTRL_EVENT.RefreshPlayerStatus,function (_,data)
        self:RefreshPlayerStatus(data)
    end)
end

function o:OnHideView()
    g_GameCtrl:DelEvent(self,EventDefine.CTRL_EVENT.RefreshPlayerStatus)
end

--设置用户信息
function o:SetPlayerInfo(players)
    --首先进行排序
    local l = {}
    for _,v in pairs(players) do
        if g_GameCtrl:IsLocal(v.pid) then
            table.insert(l,v)
        end
    end
    for _,v in pairs(players) do
        if not g_GameCtrl:IsLocal(v.pid) then
            table.insert(l,v)
        end
    end

    for i=1,#self.m_PlayerInfos do
        local data = l[i]
        if data then 
            self.m_PlayerInfos[i]:SetPlayerInfo(data)
            self.m_PlayerInfos[i]:SetActive(true)
        else
            self.m_PlayerInfos[i]:SetActive(false)
        end
    end
end

--更新用户信息
function o:RefreshPlayerStatus(data)
    for i,playerInfo in ipairs(self.m_PlayerInfos) do
        if playerInfo:GetPid() == data.pid then
            local player = g_GameCtrl:GetPlayer(data.pid)
            playerInfo:SetPlayerInfo(player)
        end
    end
end

return o