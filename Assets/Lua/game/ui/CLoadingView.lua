local o = class("CLoadingView",CViewBase)

o.Config = {
    PrefabPath = "ChinaTown/UI/Common/LoadingView",
    Layer = UILayers.TopLayer,
    Recycle = true,
    KeepOnSwitch = true --在场景切换时不关闭
}

local contents  ={
    "努力加载中",
    "努力加载中.",
    "努力加载中..",
    "努力加载中...",
    "努力加载中....",
    "努力加载中.....",
}

function o.ctor(self,cb)
    CViewBase.ctor(self, cb)
    self.m_PrefabPath = o.Config.PrefabPath
    self.m_Layer = o.Config.Layer
    self.m_Recycle = o.Config.Recycle
end

function o.OnCreateView(self)
    self.m_LoadingText = self:GetUI(1,UIText)
    self.m_LoadingImage = self:GetUI(2,UIImage)
end


--窗口激活后调用
function o.OnShowView(self)
    self.m_LoadingImage.fillAmount = 0

    self.m_TextCount = 1
    self:DelayCall(0.3,"TextUpdate")
end
--窗口隐藏后调用
function o.OnHideView(self)
	self:StopDelayCall("TextUpdate")
end

--设置进度
function o:SetProgress(val)
    self.m_LoadingImage.fillAmount = val
end

function o:TextUpdate()
    self.m_LoadingText = tostring(contents[self.m_TextCount])
    self.m_TextCount = self.m_TextCount + 1
    if self.m_TextCount > #contents then
        self.m_TextCount = 1
    end
    return true
end

return o