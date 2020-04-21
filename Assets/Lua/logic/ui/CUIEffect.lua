local o = class("CUIEffect",CObject)

function o.ctor(self,clone,args)
    CObject.ctor(self,clone,true)

    self.m_ID = args.id
    self.m_EndTime = args.endTime
    if not args.parent then
        local layer = g_ViewCtrl:GetLayer(args.layer)
        self.m_Parent = layer.transform
    else
        self.m_Parent = args.parent
    end
	self.transform:SetParent(self.m_Parent,false)
	self.transform.localPosition = Vector3.New(args.pos.x,args.pos.y,0)
    self.transform.localScale = Vector3.New(1,1,1)
    if args.cb then
        args.cb(self)
    end
end

function o:GetID()
    return self.m_ID
end
--获得结束时间
function o:GetEndTime()
    return self.m_EndTime
end

return o