local CObject = class("CObject", CDelayCallBase)

function CObject.ctor(self, obj,isUI)
    CDelayCallBase.ctor(self)
    --这两个主要对外使用
    self.gameObject = obj
	self.transform = obj.transform

	self.m_GameObject = obj
	self.m_Transform = obj.transform
    self.m_InstanceID = nil
    self.m_DestroyOnRecycle = nil
	self.m_IsDestroy = false
	
	if isUI then
		self.rectTransform = self:GetComponent(typeof(CS.UnityEngine.RectTransform))
		assert(self.rectTransform)
	end
end

--添加在回收时需要销毁的物体
function CObject.AddDestroyOnRecycle(self, obj)
	if not self.m_DestroyOnRecycle then
		self.m_DestroyOnRecycle = {}
	end
	table.insert(self.m_DestroyOnRecycle, weakref(obj))
end

--复用或者创建一个obj
function CObject.ReuseOrCreate(cls,...)
	local obj = g_ResCtrl:GetObjectFromCache(cls.classname)
	if not obj then
		obj = cls.New(...)
	end
	return obj
end

--回收
function CObject.Recycle(self)
	if self.m_DestroyOnRecycle then
		for _, ref in pairs(self.m_DestroyOnRecycle) do
			local obj = getrefobj(ref)
			if obj then
				obj:Destroy()
			end
		end
		self.m_DestroyOnRecycle = nil
	end

	self:SetActive(false)
	g_ResCtrl:PutObjectInCache(self.classname, self)
end

function CObject.SetActive(self, bActive)
	if self:GetActive() ~= bActive then
		self:OnActive(bActive)
		self.m_GameObject:SetActive(bActive)
	end
end

function CObject.ReActive(self)
	self:SetActive(false)
	self:SetActive(true)
end


function CObject.OnActive(self, bActive)
	--override
end

function CObject.GetActive(self, bHierarchy)
	if bHierarchy then
		return self.m_GameObject.activeInHierarchy
	else
		return self.m_GameObject.activeSelf
	end
end

function CObject.Destroy(self)
	if not self:IsDestroy() then
		CS.UnityEngine.GameObject.Destroy(self.m_GameObject)
	end
	self.m_DestroyOnRecycle = nil
	self.m_FindTrans = nil
	self.m_IsDestroy = true
end

function CObject.IsDestroy(self)
	return self.m_IsDestroy
end

function CObject.GetInstanceID(self)
	if not self.m_InstanceID then
		self.m_InstanceID = self.m_GameObject:GetInstanceID()
	end
	return self.m_InstanceID
end

function CObject.IsDestroy(self)
	if not self.m_IsDestroy then
		self.m_IsDestroy = Utils.IsNil(self.m_GameObject)
	end
	return self.m_IsDestroy
end

--是否被回收
function CObject.IsRecycle(self)
	return self.m_Recycle
end

function CObject.AddComponent(self, sType)
	return self.m_GameObject:AddComponent(sType)
end

function CObject.GetComponent(self, sType)
	local component = self.m_GameObject:GetComponent(sType)
	return component
end

return CObject