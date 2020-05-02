local o = class("CLocation",CObject,CGameObjContainer)

function o.ctor(self, obj,args)
    CObject.ctor(self,obj,true)
    CGameObjContainer.ctor(self,obj)

    self.m_Id = args.id
    self.m_AreaId = args.areaId
    self.m_Shop = nil

    self.m_LocationBtn = self:GetUI(1,UIButton)
    self.m_LocationEventHandler = self:GetUI(1,typeof(CS.UIEventHandler))
    self.m_OwnerColorImage = self:GetUI(1,UIImage)
    self.m_IdText = self:GetUI(2,UIText)
    self.m_ShopParent = self:GetGameObject(3)
    self.m_ShopImage = self:GetUI(4,UIImage)
    self.m_ShopPointText = self:GetUI(5,UIText)
    
    self:ShowID()
    self.m_LocationBtn.onClick:AddListener(function ()
        self:LocationOnClick()
    end)

    self.m_LocationEventHandler.onClick = function (eventData)
        if eventData.button == CS.UnityEngine.EventSystems.PointerEventData.InputButton.Right then
            self:LocationOnRightClick()
        end
    end
end

--显示id
function o:ShowID()
    self.m_IdText.text = tostring(self.m_Id)
end

--隐藏id
function o:HideID()
    self.m_IdText.text = ""
end

--恢复商铺
function o:ShowShop()
    self:SetShop(self.m_Shop) 
end

--添加按钮事件
function o:LocationOnClick()
    if self.m_Shop then
        --如果已经设置了店铺，查看一波位置
        self:ShowID()
        self.m_ShopParent:SetActive(false)

        self:DelayCall(1,"ShowShop")
    else
        local view = CCursorView:GetView()
        if view  then
            local data = view:GetData()
            if data and data.event == EventDefine.CURSOR_EVENT.PutShop then
                view:ClearData()
                NetBattle.C2GSSetShopToLocation(self.m_Id,data.shop) 
            end
        end
    end
end

--添加右键事件
function o:LocationOnRightClick()
    NetBattle.C2GSSetShopToLocation(self.m_Id,0) 
end

--设置属主颜色
function o:SetOwnerColor(color)
    self.m_OwnerColorImage.color = color
end

--设置商店
function o:SetShop(shop)
    self.m_Shop = shop
    if shop == nil then
        self.m_ShopParent:SetActive(false)
        self:ShowID()
        return
    end

    local point = ChinaTownData.shop[shop]
    local path = ChinaTownRes.img.shopImagePath .. shop
    g_ResCtrl:LoadImage(self.m_ShopImage,path)
    self.m_ShopPointText.text = tostring(point)
    self.m_ShopParent:SetActive(true)

    --因为设置了商铺，因此要清除掉位置的显示
    self:HideID()
end

function o:Reset()
    self:SetOwnerColor(Color.New(0,0,0,0))
    self:SetShop(nil)
end



return o