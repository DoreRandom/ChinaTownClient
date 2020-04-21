local o = class("CRankInfo",CObject,CGameObjContainer)

function o:ctor(obj)
    CObject.ctor(self,obj,true)
    CGameObjContainer.ctor(self,obj)

    self.m_RankImage = self:GetUI(1,UIImage)
    self.m_ColorImage = self:GetUI(2,UIImage)
    self.m_HeadImage = self:GetUI(3,UIImage) 
    self.m_NameText = self:GetUI(4,UIText) 
    self.m_RankText = self:GetUI(5,UIText)
    self.m_ScoreText = self:GetUI(6,UIText)
    self.m_MoneyText = self:GetUI(7,UIText)
end

--显示排名
function o:ShowRank(rankData)
    if not rankData then
        self.m_RankImage.color = Color.New(233/255,235/255,209/255,1)
        self.m_ColorImage.color =  Color.New(0,0,0,0)
        self.m_HeadImage.color = Color.New(0,0,0,0)
        self.m_NameText.text = ""
        self.m_RankText.text = ""
        self.m_ScoreText.text = ""
        self.m_MoneyText.text = ""
    else  
        if g_GameCtrl:IsLocal(rankData.pid) then
            self.m_RankImage.color = Color.New(1,1,1,1)
        else
            self.m_RankImage.color = Color.New(233/255,235/255,209/255,1)
        end

        self.m_ColorImage.color = g_GameCtrl:GetPlayerColor(rankData.pid) or Color.New(1,1,1,1)
        self.m_HeadImage.color = Color.New(1,1,1,1)

        local path = string.format(ChinaTownRes.img.headFormatPath,rankData.head)
        g_ResCtrl:LoadImage(self.m_HeadImage,path)
        self.m_NameText.text = rankData.name

        local cnNum = {"一","二","三","四","五","六","七","八","九","十"}

        self.m_RankText.text = string.format("第%s名",cnNum[rankData.rank])
        self.m_ScoreText.text = tostring(rankData.score)
        self.m_MoneyText.text = tostring(rankData.money)

    end
end

return o