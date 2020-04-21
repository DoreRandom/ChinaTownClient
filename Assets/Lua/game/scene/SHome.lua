local o = class("SHome",CBaseScene)

function o:OnEnter()
    self:AddPreloadResources(CHomeView.Config.PrefabPath,classtype.GameObject)
    self:AddPreloadResources(CRoomChatView.Config.PrefabPath,classtype.GameObject)
    self:AddPreloadResources(CRoomView.Config.PrefabPath,classtype.GameObject)
    self:AddPreloadResources(CJoinRoomView.Config.PrefabPath,classtype.GameObject)
end

function o:OnComplete()
    CHomeView:ShowView()
end


return o