local o = class("CHelpView",CViewBase)

o.Config = {
    PrefabPath = "ChinaTown/UI/GameMain/HelpView",
    Layer = UILayers.InfoLayer,
    Recycle = true
}

function o.ctor(self,cb)
    CViewBase.ctor(self, cb)
    self.m_PrefabPath = o.Config.PrefabPath
    self.m_Layer = o.Config.Layer
    self.m_Recycle = o.Config.Recycle
end

function o.OnCreateView(self)
    self.m_RuleBtn = self:GetUI(1,UIButton)
    self.m_OptionBtn = self:GetUI(2,UIButton)
    self.m_CloseBtn = self:GetUI(3,UIButton)

    self.m_RuleGo =self:GetGameObject(4)
    self.m_OptionGo =self:GetGameObject(5)

    self.m_RuleBtn.onClick:AddListener(callback(self,"RuleOnClick"))
    self.m_OptionBtn.onClick:AddListener(callback(self,"OptionOnClick"))
    self.m_CloseBtn.onClick:AddListener(callback(self,"CloseOnClick"))
end

function o:RuleOnClick()
    self.m_OptionGo:SetActive(false)
    self.m_RuleGo:SetActive(true)
end

function o:OptionOnClick()
    self.m_RuleGo:SetActive(false)
    self.m_OptionGo:SetActive(true)
end

function o:CloseOnClick()
    self:CloseView()
end

return o