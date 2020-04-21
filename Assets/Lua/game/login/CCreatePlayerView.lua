local o = class("CCreatePlayerView",CViewBase)

o.Config = {
    PrefabPath = "ChinaTown/UI/Login/CreatePlayerView",
    Layer = UILayers.NormalLayer,
    Recycle = true
}

function o.ctor(self,cb)
    CViewBase.ctor(self, cb)
    self.m_PrefabPath = o.Config.PrefabPath
    self.m_Layer = o.Config.Layer
    self.m_Recycle = o.Config.Recycle

    --data
    self.m_HeadId = HEAD_RANGE.Min
end

function o.OnCreateView(self)
    --container
    self.m_HeadImage = self:GetUI(1,UIImage)
    self.m_HeadBtn = self:GetUI(2,UIButton)
    self.m_NameInput = self:GetUI(3,UIInputField)
    self.m_ConfirmBtn = self:GetUI(4,UIButton)
    self.m_SelectionViewPanel = self:GetGameObject(5)
    self.m_SelectionParent = self:GetTransform(6)
    self.m_SelectionPrefab = self:GetGameObject(7)

    --显示默认头像
    self:ShowHeadImage()
    --创建选项
    self:CreateSelection()

    self.m_HeadBtn.onClick:AddListener(function ()
        self:OnClickHead()
    end)
    self.m_ConfirmBtn.onClick:AddListener(function ()
        self:OnClickConfirm()
    end)
end

--显示headid的头像
function o:ShowHeadImage()
    local path = string.format(ChinaTownRes.img.headFormatPath,self.m_HeadId)
    g_ResCtrl:LoadImage(self.m_HeadImage,path)
end
--创建选项
function o:CreateSelection()
    for index = HEAD_RANGE.Min,HEAD_RANGE.Max do
        local go = CS.UnityEngine.GameObject.Instantiate(self.m_SelectionPrefab) 
        go.transform:SetParent(self.m_SelectionParent)
        go.transform.localPosition = Vector3.New(0,0,0)
        go.transform.localScale = Vector3.New(1,1,1)
        go:SetActive(true)


        local container = CGameObjContainer.New(go)
        local selectionBtn = container:GetUI(1,UIButton)
        local selectionImage = container:GetUI(2,UIImage)

        local path = string.format(ChinaTownRes.img.headFormatPath,index)
        g_ResCtrl:LoadImage(selectionImage,path)

        local headId = index
        selectionBtn.onClick:AddListener(function ()
            self:OnClickSelection(headId)
        end)

    end
end
--点击选择头像
function o:OnClickHead()
    self.m_SelectionViewPanel:SetActive(true)
end
--点击确认
function o:OnClickConfirm()
    NetLogin.C2GSCreatePlayer(self.m_NameInput.text,self.m_HeadId)
end
--点击选项
function o:OnClickSelection(headId)
    self.m_HeadId = headId
    self:ShowHeadImage()
    self.m_SelectionViewPanel:SetActive(false)
end

function o:OnShowView()
    self:DelayCall(0,"Update")
end

function o:OnHideView()
    self:StopDelayCall("Update")
end

--检测名字程度，多余的裁减掉
function o:CheckName()
    if string.len(self.m_NameInput.text) > 10 then
        self.m_NameInput.text = string.sub(self.m_NameInput.text,1,10)
    end
end
function o:Update()
    self:CheckName()
    return true
end

return o