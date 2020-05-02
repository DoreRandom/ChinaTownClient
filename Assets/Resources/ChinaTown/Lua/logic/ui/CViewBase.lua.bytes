local CViewBase = class("CViewBase", CObject,CGameObjContainer)

function CViewBase.ctor(self, cb)
    self.m_Layer = UILayers.NormalLayer --默认的layer
    self.m_ShowID = Utils.GetUniqueID() --id越大，越晚调用ShowView
    self.m_LoadDoneFunc = cb
    self.m_ShowCB = nil
    self.m_HideCB = nil

    self.m_PrefabPath = nil

    self.m_IsActive = nil
end

--获得layer
function CViewBase.GetLayer(self)
    return self.m_Layer
end

--显示id
function CViewBase.GetShowID(self)
	return self.m_ShowID
end

--获得prefab
function CViewBase.GetPrefabPath(self)
    return self.m_PrefabPath
end

--设置显示id
function CViewBase.SetShowID(self, id)
	self.m_ShowID = id
end
--设置加载后的函数
function CViewBase.SetLoadDoneCB(self, cb)
	self.m_LoadDoneFunc = cb
end
--设置显示函数
function CViewBase.SetShowCB(self,cb)
    self.m_ShowCB = cb
end
--设置隐藏后的函数
function CViewBase.SetHideCB(self, cb)
	self.m_HideCB = cb
end

function CViewBase.GetLoadDoneCB(self)
    return self.m_LoadDoneFunc 
end
--加载完资源后调用
function CViewBase.OnViewLoad(self,oClone)
    if not oClone then
        print("CViewBase:OnViewLoad 无法加载页面")
        return
    end

    CObject.ctor(self,oClone,true)
    CGameObjContainer.ctor(self,oClone)
    self:OnCreateView()
end

--给继承者使用
function CViewBase.OnCreateView(self)
    
end

--如果该ui面板不在cleanup中释放，则调用
function CViewBase.OnCleanUp(self)
    
end

function CViewBase.SetActive(self,bActive)
    if self.m_IsActive == bActive then
		return
    end
    self.m_IsActive = bActive
    if bActive then
        self:OnShowView()
    else
        self:OnHideView()
    end
    CObject.SetActive(self,bActive)
end

--窗口激活后调用
function CViewBase.OnShowView(self)
    if self.m_ShowCB then
        self.m_ShowCB()
    end
end
--窗口隐藏后调用
function CViewBase.OnHideView(self)
	if self.m_HideCB then
		self.m_HideCB()
	end
end

--显示view
function CViewBase.ShowView(cls,cb)
    return g_ViewCtrl:ShowView(cls,cb)
end
--获得
function CViewBase.GetView(cls)
	return g_ViewCtrl:GetView(cls)
end
--关闭
function CViewBase.CloseView(cls)
	g_ViewCtrl:CloseView(cls)
end

return CViewBase