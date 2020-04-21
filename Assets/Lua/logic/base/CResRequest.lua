--用于异步加载resources目录下的文件，主要用于editor测试
local CResRequest = class("CResRequest",CDelayCallBase)

function CResRequest.ctor(self,path,ltype,cb)
    CDelayCallBase.ctor(self)
    self.m_Request = CS.UnityEngine.Resources.LoadAsync(path,ltype)
    self.m_Callback = {cb}
    self.m_Type = ltype
    self.m_Path = path
    self.m_ID = GetUniqueID()
end

function CResRequest.GetID(self)
    return self.m_ID
end

--添加回调函数
function CResRequest.AddCallback(self,cb)
    table.insert(self.m_Callback,cb)
end

function CResRequest.Update(self)
    if not self.m_Request.isDone then
        return true
    end

    for _,callback in ipairs(self.m_Callback) do
        local asset = self.m_Request.asset
        assert(asset,string.format("加载失败 %s",self.m_Path))
        callback(asset,self.m_Path)
    end
end

return CResRequest