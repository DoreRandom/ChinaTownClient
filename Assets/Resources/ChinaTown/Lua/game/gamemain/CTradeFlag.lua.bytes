local o = class("CTradeFlag",CObject,CGameObjContainer)

function o:ctor(prefab,parent)
    local clone = CS.UnityEngine.GameObject.Instantiate(prefab)
    CObject.ctor(self,clone,true)
    
    self.m_Parent = parent

    self.m_Image = self:GetComponent(UIImage)
end

function o:Show(x,y,color)
    self.transform:SetParent(self.m_Parent)
    self.m_Image.color = color 
    self.rectTransform.localScale = Vector3.New(1,1,1)
    self.rectTransform.localPosition = Vector3.New(x,y,0)
    self:SetActive(true)
end

return o