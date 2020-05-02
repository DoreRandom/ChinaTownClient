local o = class("CYearView",CViewBase)

o.Config = {
    PrefabPath = "ChinaTown/UI/GameMain/YearView",
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
    self.m_YearRect = self:GetUI(1,UIRectTransform)
    self.m_NextYearBtn = self:GetUI(2,UIButton)
    self.m_VoteText = self:GetUI(3,UIText)
    self.m_NextYearText = self:GetUI(4,UIText)

    self.m_NextYearBtn.onClick:AddListener(function ()
        self:NextYearOnClick()
    end)
end

function o:NextYearOnClick()
    NetBattle.C2GSNextYear()
end

function o:OnHideView()
    self.m_YearRect.localPosition = Vector3.New(-79.4,10,0)
end


--[[
    year 年数
    vote 已经投票下一年的人数
]]
function o:RefreshYear(args)
    local x = -79.4 + (args.year -1) * 32
    self.m_YearRect:DOLocalMoveX(x,1)
    self.m_VoteText.text = string.format("%s|%s",args.vote,g_GameCtrl:GetPlayerCount()) 
    self.m_NextYearText.text = args.nextYear and "已锁定" or "下一年"
end

return o