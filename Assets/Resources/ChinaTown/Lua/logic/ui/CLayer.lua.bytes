local CLayer = class("CLayer",CObject)

--layer较为特殊 --TODO 这里因为g_ViewCtrl尚未构造完成，因此需要传过来一个
function CLayer.ctor(self,layer,viewCtrl)
    local obj = UnityEngine.GameObject(layer.Name)

    self.m_Canvas = obj:AddComponent(typeof(CS.UnityEngine.Canvas))
    self.m_CanvasScaler = obj:AddComponent(typeof(CS.UnityEngine.UI.CanvasScaler))
    self.m_GraphicRaycaster = obj:AddComponent(typeof(CS.UnityEngine.UI.GraphicRaycaster))
    
    obj.transform:SetParent(viewCtrl:GetUIRoot())
    
    CObject.ctor(self,obj,true)
    
    --ui layer
    self.gameObject.layer = 5
    --canvas
    self.m_Canvas.renderMode = CS.UnityEngine.RenderMode.ScreenSpaceCamera
	self.m_Canvas.worldCamera = viewCtrl:GetUICamera()
	self.m_Canvas.planeDistance = layer.PlaneDistance
	self.m_Canvas.sortingLayerName = SortingLayerNames.UI
    self.m_Canvas.sortingOrder = layer.OrderInLayer
    
    --scaler
    self.m_CanvasScaler.uiScaleMode = CS.UnityEngine.UI.CanvasScaler.ScaleMode.ScaleWithScreenSize
	self.m_CanvasScaler.screenMatchMode = CS.UnityEngine.UI.CanvasScaler.ScreenMatchMode.MatchWidthOrHeight
    self.m_CanvasScaler.referenceResolution = viewCtrl:GetResolution()
    
    -- window order
	self.m_TopWindowOrder = layer.OrderInLayer
	self.m_MinWindowOrder = layer.OrderInLayer
    
end

--获得order
function CLayer.PopWindowOrder(self)
    local cur = self.m_TopWindowOrder
	self.m_TopWindowOrder = self.m_TopWindowOrder + g_ViewCtrl:GetMaxOderPerWindow()
	return cur
end

--归还order
function CLayer.PushWindowOrder(self)
	assert(self.m_TopWindowOrder > self.m_MinWindowOrder)
	self.m_TopWindowOrder = self.m_TopWindowOrder - g_ViewCtrl:GetMaxOderPerWindow()
end

--鼠标坐标转canvas坐标
function CLayer.MouseToCanvasPosition(self)
    local mousePos = CS.UnityEngine.Input.mousePosition
    local ok,pos = CS.UnityEngine.RectTransformUtility.ScreenPointToLocalPointInRectangle(
        self.rectTransform,
        Vector2.New(mousePos.x,mousePos.y),
        self.m_Canvas.worldCamera
    );
    return ok,pos
end

return CLayer