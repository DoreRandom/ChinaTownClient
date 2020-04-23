local o = class("CShopCard",CObject,CGameObjContainer)

--[[
    args
        cb 回调函数
        shopId
]]
function o.ctor(self, obj,args)
    CObject.ctor(self,obj,true)
    CGameObjContainer.ctor(self,obj)    

    self.m_ShopId = args.shopId

    self.m_ShopImage = self:GetUI(1,UIImage)
    self.m_CountText = self:GetUI(2,UIText)
    self.m_PointText = self:GetUI(3,UIText)
    self.m_ShopBtn = self:GetUI(4,UIButton)
    self.m_ShopEventHandler = self:GetUI(4,typeof(CS.UIEventHandler))

    if args.leftClick then
        self.m_ShopBtn.onClick:AddListener(args.leftClick)
    end

    if args.rightClick then
        self.m_ShopEventHandler.onClick = function (eventData)
            if eventData.button == CS.UnityEngine.EventSystems.PointerEventData.InputButton.Right then
                args.rightClick()
            end
        end
    end

    if args.onEnter then
        self.m_ShopEventHandler.onEnter = function ()
            args.onEnter()
        end
    end

    if args.onExit then
        self.m_ShopEventHandler.onExit = function ()
            args.onExit()
        end
    end

    self:ShowShop()
end

--获得商店的sprite
function o:GetShopSprite()
    return self.m_ShopImage.sprite
end

--获得商店id
function o:GetShopId()
    return self.m_ShopId
end
--显示商店
function o:ShowShop()
    local path = ChinaTownRes.img.shopImagePath .. self.m_ShopId
    g_ResCtrl:LoadImage(self.m_ShopImage,path)

    self.m_PointText.text = tostring(ChinaTownData.shop[self.m_ShopId])
    
end
--设置商店卡数量
function o:SetCount(count)
    self.m_Count = count
    if count ==0 then
        self.m_CountText.text = ""
        self.m_ShopImage.color = Color.New(1,1,1,0.2)
    else
        self.m_CountText.text = tostring(count)
        self.m_ShopImage.color = Color.New(1,1,1,1)
    end
end

function o:GetCount()
    return self.m_Count or 0
end



return o