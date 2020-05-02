--用于记录和更新游戏角色的属性
local o = class("CAttrCtrl",CCtrlBase)

function o:ctor()
    CCtrlBase.ctor(self)
    --tip 这里为了兼容，不使用命名方式
    self.pid = nil
    self.name = nil
    self.head = nil
    self.score = nil
end

function o:GetPid()
    return self.pid
end

function o:SetPlayerInfo(playerInfo)
    self.pid = playerInfo.pid
    self.name = playerInfo.name
    self.head = playerInfo.head
    self.score = playerInfo.score

    --通知订阅者
    self:TriggerEvent(EventDefine.CTRL_EVENT.SetPlayerInfo,playerInfo)
end

function o:GS2CRefreshPlayer(data)
    local status  = data.status
    if self.pid ~= status.pid then
        return
    end
    for k,v in pairs(status) do
        self[k] = v
    end
    --通知订阅者
    self:TriggerEvent(EventDefine.CTRL_EVENT.SetPlayerInfo,self:GetPlayerInfo())
end

function o:GetPlayerInfo()
    return {
        name = self.name,
        head = self.head,
        score = self.score,
        pid = self.pid
    }
end

return o