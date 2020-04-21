local o = class("CCursorView",CViewBase)

o.Config = {
    PrefabPath = "ChinaTown/UI/Common/CursorView",
    Layer = UILayers.TopLayer,
    Recycle = true
}

function o.ctor(self,cb)
    CViewBase.ctor(self, cb)
    self.m_PrefabPath = o.Config.PrefabPath
    self.m_Layer = o.Config.Layer
    self.m_Recycle = o.Config.Recycle

end

function o.OnCreateView(self)
    --container
    self.m_CursorImage = self:GetUI(1,UIImage)
    self.m_Cursor = self.m_CursorImage.gameObject
end

--窗口激活后调用
function o:OnShowView()
    self:DelayCall(0,"Update")
end

--隐藏后调用
function o:OnHideView()
    self:StopDelayCall("Update")
end

--[[
    args
        sprite
        data
]]
function o:SetCursor(args)
    self.m_Data = args.data
    self.m_CursorImage.sprite = args.sprite
    self.m_Cursor:SetActive(true)
    self.m_CursorRectTransform = self.m_Cursor:GetComponent(typeof(CS.UnityEngine.RectTransform))

    CS.UnityEngine.Cursor.visible = false
end

function o:GetData()
    return self.m_Data
end

function o:ClearData()
    self.m_Data = nil
    self.m_Cursor:SetActive(false)
    CS.UnityEngine.Cursor.visible = true
end

function o:Update()
    if self.m_Data then
        if CS.UnityEngine.Input.GetMouseButtonDown(1) then
            self:ClearData()
        else
            local ok,pos  = g_ViewCtrl:MouseToCanvasPosition()
            self.m_CursorRectTransform.localPosition = Vector3.New(pos.x,pos.y,0)
        end
    end
    
    return true
end



return o