local o = class("SLogin",CBaseScene)

function o:OnEnter()
    self:AddPreloadResources(CLoginView.Config.PrefabPath,classtype.GameObject)
    self:AddPreloadResources(CCreatePlayerView.Config.PrefabPath,classtype.GameObject)

    g_LoginCtrl:CleanUp()
end

function o:OnComplete()
    g_NetCtrl:SetCallClose(false)
    g_NetCtrl:Dispose()
    CLoginView:ShowView()
    --播放bgm
    g_AudioCtrl:PlayBgm(ChinaTownRes.sound.bgmPath,0.5)
end

return o