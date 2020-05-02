local o = class("CRankView",CViewBase)

o.Config = {
    PrefabPath = "ChinaTown/UI/GameMain/RankView",
    Layer = UILayers.InfoLayer,
    Recycle = true
}

function o.ctor(self,cb)
    CViewBase.ctor(self, cb)
    self.m_PrefabPath = o.Config.PrefabPath
    self.m_Layer = o.Config.Layer
    self.m_Recycle = o.Config.Recycle

    self.m_RankInfos = {}
end

function o.OnCreateView(self)
    --container
    
    self.m_HallBtn = self:GetUI(2,UIButton)
    self.m_TeamBtn = self:GetUI(3,UIButton)
    self.m_ExitBtn = self:GetUI(4,UIButton)

    local rankGroup = self:GetTransform(1)
    for i=1,rankGroup.childCount do
        local t = rankGroup:GetChild(i-1)
        local go = t.gameObject
        self.m_RankInfos[i] = CRankInfo.New(go)
    end

    self.m_HallBtn.onClick:AddListener(function ()
        self:OnClickHall()
    end)
    self.m_TeamBtn.onClick:AddListener(function ()
        self:OnClickTeam()
    end)
    self.m_ExitBtn.onClick:AddListener(function ()
        self:OnClickExit()
    end)
end

--click
function o:OnClickHall()
    NetPlayer.C2GSBackToHall()
end

function o:OnClickTeam()
    NetPlayer.C2GSBackToTeam()
end

function o:OnClickExit()

    CS.UnityEngine.Application.Quit()
end

--显示排名
function o:ShowRank(data)
    local rankInfos = data.rankInfos
    
    for rank,rankData in ipairs(rankInfos) do
        rankData.rank = rank 
    end 

    for i,rankInfo in ipairs(self.m_RankInfos) do
        local rankData = rankInfos[i]
        rankInfo:ShowRank(rankData)
    end
end


return o