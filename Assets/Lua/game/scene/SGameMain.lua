local o = class("SGameMain",CBaseScene)

function o:OnEnter()
	self:AddPreloadResources(CBackgroundView.Config.PrefabPath,classtype.GameObject)
	self:AddPreloadResources(CGameView.Config.PrefabPath,classtype.GameObject)
	self:AddPreloadResources(CShopView.Config.PrefabPath,classtype.GameObject)
	self:AddPreloadResources(CPlayerInfoView.Config.PrefabPath,classtype.GameObject)
	self:AddPreloadResources(CYearView.Config.PrefabPath,classtype.GameObject)
	self:AddPreloadResources(COptionView.Config.PrefabPath,classtype.GameObject)
	self:AddPreloadResources(CGameChatView.Config.PrefabPath,classtype.GameObject)
	self:AddPreloadResources(CCursorView.Config.PrefabPath,classtype.GameObject)
	self:AddPreloadResources(CSelectionView.Config.PrefabPath,classtype.GameObject)
	self:AddPreloadResources(CTradeView.Config.PrefabPath,classtype.GameObject)
	self:AddPreloadResources(CHelpView.Config.PrefabPath,classtype.GameObject)
	self:AddPreloadResources(CShopInfoView.Config.PrefabPath,classtype.GameObject)
end

function o:OnComplete()
	CBackgroundView:ShowView()
	CGameView:ShowView()
	CShopView:ShowView()
	CPlayerInfoView:ShowView()
	CYearView:ShowView()
	COptionView:ShowView()
	CGameChatView:ShowView()
	CCursorView:ShowView()
end


return o