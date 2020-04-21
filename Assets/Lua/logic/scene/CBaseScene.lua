local o = class("CBaseScene")

function o.ctor(self)
    self.m_PreloadResources = {}
    self:OnCreate()
end

--一些需要全局保存的状态
function o:OnCreate()
    
end

--加载前初始化
function o:OnEnter()
    
end

--离开场景清理
function o:OnComplete()
    
end

--添加需要预加载的资源
function o:AddPreloadResources(path,ltype)
    self.m_PreloadResources[path] = ltype
end

--是否加载完毕
function o:LoadDone()
    return self.m_LoadDone
end

--预加载
function o:PreloadProgress()
    local totalCount = table.count(self.m_PreloadResources)
	local count = 0
	if totalCount  == 0 then
		self.m_LoadDone = true
	else
		self.m_LoadDone = false
	end
     
    local function cb(asset, path)
		if self.m_PreloadResources[path] then
			count = count +1
			if count >= totalCount then
				print("CBaseScene:PreloadProgress init done!!! ".. count)
				self.m_LoadDone = true
			end
		end
	end
	for path, ltype in pairs(self.m_PreloadResources) do
		g_ResCtrl:LoadAsset(path,ltype, cb)
	end
end

function o:OnLeave(self)
    
end



return o