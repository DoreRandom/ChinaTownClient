local o = class("CUIEffectCtrl",CCtrlBase)

function o.ctor(self)
    CCtrlBase.ctor(self)
    
    self.m_Prefabs = {}
    self.m_Effects = {}
    self.m_DelayEffects = {}
end
--[[
    添加特效
    aliveTime,
    startTime,
    isCached,
    layer,
    path,
    pos,
    parent
]]
function o:AddEffect(args)
    args.id = GetUniqueID()
    args.StartTime = args.StartTime or 0
    args.beginTime = Time.time + args.StartTime
    args.endTime = args.beginTime + args.aliveTime
    if args.StartTime == 0 then
        self:AddEffectInner(args)
        return
    end
    
    self.m_DelayEffects[args.id] = args
end

function o:AddEffectInner(args)
    local prefab = self.m_Prefabs[args.path]
    if prefab then
        local clone =  CS.UnityEngine.GameObject.Instantiate(prefab)
        local effect =  CUIEffect.New(clone,args)
        self.m_Effects[effect:GetID()] = effect
        return
    end
    g_ResCtrl:LoadAsync(args.path,typeof(CS.UnityEngine.GameObject),function (prefab,path)
        if args.isCached then
            self.m_Prefabs[args.path] = prefab
        end
        local clone =  CS.UnityEngine.GameObject.Instantiate(prefab)
        local effect = CUIEffect.New(clone,args)
        self.m_Effects[effect:GetID()] = effect
    end)
end

function o:Update()
    
    for id,args in pairs(self.m_DelayEffects) do
        if args.beginTime >= Time.time then
            self:AddEffectInner(args)
            self.m_DelayEffects[id] = nil
        end
    end
    for id,effect in pairs(self.m_Effects) do
        if effect:GetEndTime() < Time.time then
            effect:Destroy()
            self.m_Effects[id] = nil
        end
    end
    return true
end



return o
