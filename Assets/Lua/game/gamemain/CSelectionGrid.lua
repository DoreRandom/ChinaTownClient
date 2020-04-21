local o = class("CSelectionGrid",CObject,CGameObjContainer)

local GridSize = 64
function o.ctor(self,obj,isCard)
    CObject.ctor(self,obj,true)
    CGameObjContainer.ctor(self,obj)
    
    if isCard then
        self.m_ConfirmBtn = self:GetUI(1,UIButton)
        self.m_SelectedImage = self:GetUI(2,UIImage)
        self.m_CardImage = self:GetUI(3,UIImage)
        self.m_CardText = self:GetUI(4,UIText)
    else
        self.m_ConfirmBtn = self:GetUI(1,UIButton)
        self.m_SelectedImage = self:GetUI(2,UIImage)
        self.m_LocationText = self:GetUI(3,UIText)
    end
end

--设置按钮点击
function o:SetButtonClick(cb)
    self.m_ConfirmBtn.onClick:AddListener(cb)
end

--设置店铺
function o:SetShop(shopId)
    local path = ChinaTownRes.img.shopImagePath .. shopId
    g_ResCtrl:LoadImage(self.m_CardImage,path)

    self.m_CardText.text = tostring(ChinaTownData.shop[shopId])
end

--设置位置
function o:SetOffset(offset,index)
    local x = offset + (index -1) * GridSize
    self.rectTransform.localPosition = Vector3.New(x,0,0)
end

--设置地点
function o:SetLocation(locationId)
    self.m_LocationText.text = tostring(locationId)
end
--标记
function o:Mark()
    self.m_SelectedImage.color = Color.New(0,1,0,1)
end
--取消标记
function o:UnMark()
    self.m_SelectedImage.color = Color.New(228/255,230/255,198/255,1)
end



return o