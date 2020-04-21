local o = class("CNotifyView",CViewBase)

o.Config = {
    PrefabPath = "ChinaTown/UI/Common/NotifyView",
    Layer = UILayers.TipLayer,
    Recycle = true,
    KeepOnSwitch = true
}

function o.ctor(self,cb)
    CViewBase.ctor(self, cb)
    self.m_PrefabPath = o.Config.PrefabPath
    self.m_Layer = o.Config.Layer
    self.m_Recycle = o.Config.Recycle
end

function o.OnCreateView(self)
    --container
    self.m_NotifyOnePrefab = self:GetGameObject(1)
    self.m_NotifyTwoPrefab = self:GetGameObject(2)
    self.m_NotifyParent = self:GetTransform(3)

    self.m_Notifys = {}
    self.m_SingleMap = {}
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
    通知窗口
    args 
        title
        content
        buttons 
            text
            cb
]]
function o:NotifyInner(title,content,buttons)
    
    local prefab = nil
    if #buttons == 2 then
        prefab = self.m_NotifyTwoPrefab
    else
        prefab = self.m_NotifyOnePrefab
    end
    if #buttons == 0 then
        buttons = { [1] = {text = "确定",cb = function () end} }
    end
    local key = title .. content
    
    if self.m_SingleMap[key] then return end
    self.m_SingleMap[key] = true


    local notify = CNotify.New(prefab,self.m_NotifyParent,title,content,buttons)
    self.m_Notifys[notify:GetID()] = notify
    
end

--[[
    关闭所有notify
]]
function o:OnCleanUp()
    for id,notify in pairs(self.m_Notifys) do
        if not notify:IsDestroy() then
            notify:Destroy()
        end
    end
    self.m_Notifys = {}
    self.m_SingleMap = {}
end

function o:Update()
    for id,notify in pairs(self.m_Notifys) do
        if notify:IsDestroy() then
            self.m_Notifys[id] = nil
            self.m_SingleMap[notify:GetKey()] = nil
        end
    end
    return true
end

function o.Notify(title,content,buttons)
    local view = CNotifyView:GetView()
    if view then
        buttons = buttons or {}
        view:NotifyInner(title,content,buttons)
    end
end


return o