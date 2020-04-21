local o = class("CChatBox",CObject)

function o.ctor(self,prefab,parent)
    local clone = CS.UnityEngine.GameObject.Instantiate(prefab)
    CObject.ctor(self,clone,true)
    self.m_Parent = parent
    self.m_MsgText = clone:GetComponentInChildren(UIText)
    self.m_ID = GetUniqueID()
end

function o:GetID()
    return self.m_ID
end

function o:Show(msg,pos)
    self.transform:SetParent(self.m_Parent)
    self.rectTransform.localScale = Vector3.New(1,1,1)
    self.rectTransform.localPosition = Vector3.New(pos.x,pos.y,0)
    self.m_MsgText.text = msg
    self.m_Over = false
    self:SetActive(true)
    self:DelayCall(3,"SetOver")
end

function o:SetOver()
    self.m_Over = true
end

function o:GetOver()
    return self.m_Over
end


return o