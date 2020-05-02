local o = class("CNotify",CObject,CGameObjContainer)

function o.ctor(self,prefab,parent,title,content,buttons)
    local obj = CS.UnityEngine.GameObject.Instantiate(prefab)
    CObject.ctor(self,obj,true)
    CGameObjContainer.ctor(self,obj)

    self.transform:SetParent(parent)
    self.rectTransform.localPosition = Vector3.New(0,0,0)
    self.rectTransform.localScale = Vector3.New(1,1,1)

    self.m_Id = GetUniqueID()

    --container
    self.m_TitleText = self:GetUI(1,UIText)
    self.m_ContentText = self:GetUI(2,UIText)
    
    self.m_FirstBtn = self:GetUI(3,UIButton)
    self.m_FirstText = self:GetUI(4,UIText)

    if #buttons == 2 then
        self.m_SecondBtn = self:GetUI(5,UIButton)
        self.m_SecondText = self:GetUI(6,UIText)
    end

    self.m_TitleText.text = title
    self.m_ContentText.text = content

    self.m_Title = title
    self.m_Content = content

    self.m_FirstBtn.onClick:AddListener(function ()
        self:Destroy()
        local cb = buttons[1].cb
        if cb then
            cb()
        end
    end)
    self.m_FirstText.text = buttons[1].text

    if #buttons == 2 then
        self.m_SecondBtn.onClick:AddListener(function ()
            self:Destroy()
            local cb = buttons[2].cb
            if cb then
                cb()
            end
        end)
        self.m_SecondText.text = buttons[2].text
    end
    
    self:SetActive(true)
end

function o:GetID()
    return self.m_Id
end

function o:GetKey()
    return self.m_Title .. self.m_Content
end

return o