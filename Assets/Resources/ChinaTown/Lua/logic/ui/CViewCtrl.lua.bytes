local CViewCtrl = class("CViewCtrl", CCtrlBase)

-- UIRoot路径
local UIRootPath = "UIRoot"
-- EventSystem路径
local EventSystemPath = "EventSystem"
-- UICamera路径
local UICameraPath = UIRootPath.."/UICamera"
-- 分辨率
local Resolution = Vector2.New(1280, 720)
-- 窗口最大可使用的相对order_in_layer
local MaxOrderPerWindow = 10

--TODO 这里是否单独创建文件或者放入define中
UILayers = {
	-- 场景UI，如：点击建筑查看建筑信息---一般置于场景之上，界面UI之下
	SceneLayer = {
		Name = "SceneLayer",
		PlaneDistance = 1000,
		OrderInLayer = 0,
	},
	-- 背景UI，如：主界面---一般情况下用户不能主动关闭，永远处于其它UI的最底层
	BackgroudLayer = {
		Name = "BackgroudLayer",
		PlaneDistance = 900,
		OrderInLayer = 1000,
	},
	-- 普通UI，一级、二级、三级等窗口---一般由用户点击打开的多级窗口
	NormalLayer = {
		Name = "NormalLayer",
		PlaneDistance = 800,
		OrderInLayer = 2000,
	},
	-- 信息UI---如：跑马灯、广播等---一般永远置于用户打开窗口顶层
	InfoLayer = {
		Name = "InfoLayer",
		PlaneDistance = 700,
		OrderInLayer = 3000,
	},
	-- 提示UI，如：错误弹窗，网络连接弹窗等
	TipLayer = {
		Name = "TipLayer",
		PlaneDistance = 600,
		OrderInLayer = 4000,
	},
	-- 顶层UI，如：场景加载
	TopLayer = {
		Name = "TopLayer",
		PlaneDistance = 500,
		OrderInLayer = 5000,
	}
}

function CViewCtrl.ctor(self)
    CCtrlBase.ctor(self)
    --所有存活的窗体
    self.m_Views = {}
    --所有可用的层级
    self.m_Layers = {}
    --窗口记录队列
    self.m_ViewStack = {}
    --是否启用记录
	self.m_EnableRecord = true
	--正在加载的窗口
	self.m_LoadingViews = {}

    --初始化组件
    self.m_GameObject = CS.UnityEngine.GameObject.Find(UIRootPath)
    self.m_Transform = self.m_GameObject.transform
    self.m_CameraGO =  CS.UnityEngine.GameObject.Find(UICameraPath)
    self.m_UICamera = self.m_CameraGO:GetComponent(typeof(CS.UnityEngine.Camera))
    self.m_Resolution = Resolution
    self.m_MaxOrderPerWindow = MaxOrderPerWindow
    CS.UnityEngine.Object.DontDestroyOnLoad(self.m_GameObject)
    local eventSystem = CS.UnityEngine.GameObject.Find(EventSystemPath)
    CS.UnityEngine.Object.DontDestroyOnLoad(eventSystem)

    assert(not Utils.IsNil(self.m_Transform))
    assert(not Utils.IsNil(self.m_UICamera))
    
    --初始化层级
    local layers = UILayers
    
    table.walksort(
    layers, 
    function(lkey, rkey)
		return layers[lkey].OrderInLayer < layers[rkey].OrderInLayer
    end,  --按照order排序
    function(index, layer)
		assert(self.m_Layers[layer.Name] == nil, "Aready exist layer : "..layer.Name)
		local newLayer = CLayer.New(layer,self)
        self.m_Layers[layer.Name] = newLayer
	end)
end

--获得UIRoot
function CViewCtrl.GetUIRoot(self)
    return self.m_Transform
end

--获得UICamera
function CViewCtrl.GetUICamera(self)
	return self.m_UICamera
end

--获得分辨率
function CViewCtrl.GetResolution(self)
	return self.m_Resolution
end

--获得窗口可用的最大order
function CViewCtrl.GetMaxOrderPerWindow(self)
	return self.m_MaxOrderPerWindow
end

--添加到layer
function CViewCtrl.AddToLayer(self,obj,layer)
	local name = nil
	if type(layer) == "string" then
		name = layer
	else
		name = layer.Name
	end
	local oLayer = self.m_Layers[name]
	obj.transform:SetParent(oLayer.transform,false)
	obj.transform.localPosition = Vector3.New(0,0,0)
	obj.transform.localScale = Vector3.New(1,1,1)
end
--获得layer
function CViewCtrl.GetLayer(self,layer)
	local name = nil
	if type(layer) == "string" then
		name = layer
	else
		name = layer.Name
	end
	return self.m_Layers[name]
end

--激活窗口
function CViewCtrl.ActiveView(self,oView,cb)
	oView:SetActive(true) --TODO 这里view需要做一些open的操作
	self:AddView(oView.classtype, oView)
	if cb then
		cb(oView)
	end
end

--显示View
function CViewCtrl.ShowView(self,cls,cb)
	local oView = self:GetView(cls)
	--如果尚未打开，则从缓存尝试读取
	if not oView then
		oView = g_ResCtrl:GetObjectFromCache(cls.classname)
		if oView then
			self:AddToLayer(oView,oView:GetLayer())
		end
	end
	if oView then
		self:ActiveView(oView,cb)
		return
	end
	--缓存中也没有，那么就需要从资源管理器中加载
	--因为为异步，在此之前，先查看是否该view在读取
	local oLoadingView = self:GetLoadingView(cls)
	if oLoadingView then
		oLoadingView:SetLoadDoneCB(cb)
		return
	end

	--设置为正在加载
	oView = cls.New(cb)
	self:SetLoadingView(cls,oView)
	g_ResCtrl:LoadCloneAsync(oView:GetPrefabPath(),function(oClone)
		--该窗口已经关闭
		local o = self:GetLoadingView(cls)
		if not o then
			CS.UnityEngine.GameObject.Destroy(oClone)
			return
		end
		--从loading移除
		self:SetLoadingView(cls,nil)
		--这里oView还未构造，暂时调用oClone
		self:AddToLayer(oClone,o:GetLayer())
		
		o:OnViewLoad(oClone)
		self:ActiveView(o,o:GetLoadDoneCB())

	end
	)
	
end


function CViewCtrl.ShowViewByClsName(self, classname, cb)
	return self:ShowView(_G[classname], cb)
end

function CViewCtrl.CloseView(self, cls)
	local oLoadingView = self:GetLoadingView(cls)
	if oLoadingView then
		self:SetLoadingView(cls, nil)
	else
		local oView = self:GetView(cls)
		if oView then
			self:DelView(oView.classtype)
			oView:SetActive(false)
			if oView:IsRecycle() then
				g_ResCtrl:PutObjectInCache(cls.classname, oView)
			else
				oView:Destroy()
			end
		end
	end
end

function CViewCtrl.AddView(self, cls, oView)
	self:SetLoadingView(cls, nil) --从loading中移除
	self.m_Views[cls.classname] = oView
end

function CViewCtrl.DelView(self, cls)
	self.m_Views[cls.classname] = nil
end

function CViewCtrl.GetView(self, cls)
	return self.m_Views[cls.classname]
end

function CViewCtrl.GetViewByName(self, classname)
	return self.m_Views[classname]
end

function CViewCtrl.GetViews(self)
	return self.m_Views
end

function CViewCtrl.GetViewCount(self)
	return table.count(self.m_Views)
end

function CViewCtrl.SetLoadingView(self, cls, oInstance)
	if oInstance then
		oInstance:SetShowID(Utils.GetUniqueID())
	end
	self.m_LoadingViews[cls.classname] = oInstance
end

function CViewCtrl.GetLoadingView(self, cls)
	return self.m_LoadingViews[cls.classname]
end


function CViewCtrl.SwitchScene(self)
	for k, v in pairs(self.m_Views) do
		if v.m_SwitchSceneClose then
			if v.CloseView then
				v:CloseView(v)
			else
				self:CloseView(v)
			end
		end
	end
	for k, v in pairs(self.m_LoadingViews) do
		if v.m_SwitchSceneClose then
			self.m_LoadingViews[k] = nil
		end
	end
end
--鼠标转canvas位置
function CViewCtrl.MouseToCanvasPosition(self)
	local layer = self:GetLayer(UILayers.NormalLayer)
    return layer:MouseToCanvasPosition() 
end

--清理
function CViewCtrl.CleanUp(self)
	for _,view in pairs(self.m_Views) do
		if not view.Config.KeepOnSwitch then
			view:CloseView()
		else
			view:OnCleanUp()
		end
	end
	self.m_LoadingViews = {}
end


return CViewCtrl
