local CGameObjContainer = class("CGameObjContainer")

function CGameObjContainer.ctor(self,obj)
    self.m_Container = obj:GetComponent(typeof(CS.GameObjectContainer))
end

--获得一个ui组件
function CGameObjContainer.GetUI(self,index,ltype)
    local go = self.m_Container:Get(index)
    if Utils.IsNil(go) then 
        return nil
    end
    
    local component =  go:GetComponent(ltype)
    if ltype == UIButton then
        component = CButton.New(component)
    end
    return component
end

--获得一个gameobject
function CGameObjContainer.GetGameObject(self,index)
    return self.m_Container:Get(index)
end

--获得transform
function CGameObjContainer.GetTransform(self,index)
    local go = self.m_Container:Get(index)
    return go.transform
end

return CGameObjContainer