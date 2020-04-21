local CResCtrl = class("CResCtrl", CDelayCallBase)

--TODO 关于资源管理器的一些配置
local ResConfig = {
    ObjectCacheMaxSize = 30
}

function CResCtrl.ctor(self)
    CDelayCallBase.ctor(self)
    self.m_UseCache = true
	self.m_IsInitDone = false --如果有资源需要预加载
	self.m_Requests = {}

    local function ObjDestroy(obj)
        obj:Destroy()
    end

	self.m_AssetCache = {
		contents = {},
		idx = 0,
		destroy = function (...)			
		end
	}

    self.m_ObjectCache = {
        root = self:GetCacheRoot("ResCacheObjectRoot",false),
        contents = {},
        idx = 0,
        destroy = ObjDestroy
	}
	self.m_InitLoadRes = {}

	self:DelayCall(0,"Update")
	
end

--获得缓存根对象
function CResCtrl.GetCacheRoot(self,sName,bActive,vPos)
    local obj = UnityEngine.GameObject(sName)
	obj:SetActive(bActive)
	if vPos then
		obj.transform.position = vPos
	end
	return obj.transform
end

--加载需要提前加载的内容
function CResCtrl.InitLoad(self)

	self.m_InitLoadRes = {
		--proto
		[NetProto.ProtoPath] = classtype.TextAsset,
		--ui
		[CLoadingView.Config.PrefabPath] = classtype.GameObject,
		[CNotifyView.Config.PrefabPath] = classtype.GameObject,
		--audio
		[ChinaTownRes.sound.clickPath] = classtype.AudioClip
	}

	local totalCount = table.count(self.m_InitLoadRes)
	local count = 0
	local function cb(asset, path)
		if self.m_InitLoadRes[path] then
			count = count +1
			if count >= totalCount then
				print("-->resource init done!!! ".. count)
				self.m_IsInitDone = true
			end
		end
	end
	for path, ltype in pairs(self.m_InitLoadRes) do
		self:LoadAsset(path,ltype, cb)
	end

	if totalCount == 0 then
		self.m_IsInitDone = true
	end
end

--是否初始化
function CResCtrl.IsInitDone(self)
	return self.m_IsInitDone
end

--存储asset
function CResCtrl.PutAssetInCache(self,path,asset)
	if self.m_AssetCache[path] then
		return
	end
	self.m_AssetCache.idx = self.m_AssetCache.idx + 1
	local dCache = {
		key = path,
		cache_obj = asset,
		all_idx = self.m_AssetCache.idx,
		time = UnityEngine.Time.realtimeSinceStartup,
	}
	self.m_AssetCache[path] = dCache.all_idx
	self.m_AssetCache.contents[dCache.all_idx] = dCache
end

--获得asset
function CResCtrl.GetAssetFromCache(self,path)
	local idx = self.m_AssetCache[path]
	if idx then
		local dCache = self.m_AssetCache.contents[idx]
		local asset = dCache.cache_obj
		return asset
	end
end

--[[
加入缓存池
matchInfo 匹配条件
]]
function CResCtrl.PutObjectInCache(self, key, oObject, dMatchInfo)
    --如果没有启用缓存，则直接销毁对象
    if not self.m_UseCache then
        self.m_ObjectCache.destroy(oObject)
		return
    end
    oObject.transform:SetParent(self.m_ObjectCache.root, false)
    self.m_ObjectCache.idx = self.m_ObjectCache.idx + 1
    --存储一个类型的object
    local dIdxGroup = self.m_ObjectCache[key] or {}
	local dCache = {
		key = key,
		cache_obj = oObject,
		match = dMatchInfo,
		time = UnityEngine.Time.realtimeSinceStartup,
		all_idx = self.m_ObjectCache.idx,
	}
	dIdxGroup[dCache.all_idx] = true
	self.m_ObjectCache[key] = dIdxGroup
    self.m_ObjectCache.contents[dCache.all_idx] = dCache
    --检测缓存的大小
	self:CheckCacheSize(self.m_ObjectCache, ResConfig.ObjectCacheMaxSize)
end
--[[
从缓存中获得object
]]
function CResCtrl.GetObjectFromCache(self, key, dMatchInfo)
	local dIdxGroup = self.m_ObjectCache[key]
	if not dIdxGroup or next(dIdxGroup) == nil then
		return
	end
	local iAllIdx, iTime
	for idx, _ in pairs(dIdxGroup) do
		local dCache = self.m_ObjectCache.contents[idx]
		if dCache.match and dMatchInfo and table.equal(dMatchInfo, dCache.match) then
			iAllIdx = idx
			break
		end
		if not iTime or dCache.time < iTime then
			iTime = dCache.time
			iAllIdx = idx
		end
	end
	local oCache = self.m_ObjectCache.contents[iAllIdx].cache_obj
	dIdxGroup[iAllIdx] = nil
	self.m_ObjectCache.contents[iAllIdx] = nil
	return oCache
end

--检查缓存池的大小，使其保存在某个size
function CResCtrl.CheckCacheSize(self, dAllCache, iSize)
	local lKeys = table.keys(dAllCache.contents)
	table.sort(lKeys)
	local iAdd = 0
	for i = #lKeys, 1, -1 do
		if iAdd >= iSize then
			local idx = lKeys[i]
			local dCache = dAllCache.contents[idx]
			dAllCache.destroy(dCache.cache_obj)
			dCache.cache_obj = nil
			if type(dAllCache[dCache.key]) == "table" then
				dAllCache[dCache.key][idx] = nil
			else
				dAllCache[dCache.key] = nil
			end
			dAllCache.contents[idx] = nil
		else
			iAdd = iAdd + 1
		end
	end
end
--异步加载资源clone
function CResCtrl.LoadCloneAsync(self,path,callback)
	local clone = self:GetObjectFromCache(path)
	if clone then
		callback(clone,path)
	end
	local prefab = self:GetAssetFromCache(path)
	if prefab then
		local clone =  CS.UnityEngine.GameObject.Instantiate(prefab)
		callback(clone,path)
	end
	local cb = function (asset,path)
		local clone =  CS.UnityEngine.GameObject.Instantiate(asset)
		callback(clone,path)
	end
	CResCtrl.LoadAsync(self,path,typeof(CS.UnityEngine.GameObject),cb)
end
--异步加载资源
function CResCtrl.LoadAsync(self,path,ltype,callback)
	local key = path .. tostring(ltype)
	local request = self.m_Requests[key]
	--如果已经在请求该资源，则将回调函数添加到request中
	if request then
		request:AddCallback(callback)
		return
	end
	if Utils.IsEditor() then
		request = CResRequest.New(path,ltype,callback)
	else
		request = CABRequest.New(path,ltype,callback)
	end
	self.m_Requests[key] = request
end

--加载资源并保存
function CResCtrl.LoadAsset(self,path,ltype,cb)
	local asset = self:GetAssetFromCache(path)
	if asset then
		cb(asset,path)
		return 
	end
	self:LoadAsync(path,ltype,function (asset,path)
		self:PutAssetInCache(path,asset)
		cb(asset,path)
	end)
end
--清理
function CResCtrl.CleanUp(self)
	self.m_Requests = {} --loading置为空
	--[[ 清空所有资源
	for index,cache in pairs(self.m_ObjectCache.contents) do
		if not self.m_InitLoadRes[cache.key] then
			self.m_ObjectCache[cache.key] = nil --清除该组索引
			local obj = self.m_ObjectCache.contents[index].cache_obj
			self.m_ObjectCache.contents[index] = nil
			obj:Destroy()
		end
	end
	for index,cache in pairs(self.m_AssetCache.contents) do
		if not self.m_InitLoadRes[cache.key] then
			self.m_AssetCache[cache.key] = nil
			self.m_AssetCache.contents[index] = nil
		end
	end
	]]
end

function CResCtrl.UpdateRequest(self)
	for k,request in pairs(self.m_Requests) do
		if not request:Update() then
			self.m_Requests[k] = nil
		end
	end
end

function CResCtrl.Update(self)
	self:UpdateRequest()
	return true
end


--extend
function CResCtrl.LoadImage(self,image,path)
	local cb = function(sprite,path)
        image.sprite = sprite
    end
    self:LoadAsset(path,typeof(CS.UnityEngine.Sprite),cb)
end
return CResCtrl