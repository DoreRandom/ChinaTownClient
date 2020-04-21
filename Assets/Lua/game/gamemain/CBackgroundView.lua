local o = class("CBackgroundView",CViewBase)

o.Config = {
    PrefabPath = "ChinaTown/UI/GameMain/BackgroundView",
    Layer = UILayers.BackgroudLayer,
    Recycle = true
}

function o.ctor(self,cb)
    CViewBase.ctor(self, cb)
    self.m_PrefabPath = o.Config.PrefabPath
    self.m_Layer = o.Config.Layer
    self.m_Recycle = o.Config.Recycle
end

return o