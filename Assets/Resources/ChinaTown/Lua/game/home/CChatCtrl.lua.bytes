--用于记录和更新游戏角色的属性
local o = class("CChatCtrl",CCtrlBase)

function o:ctor()
    CCtrlBase.ctor(self)
    --tip 这里为了兼容，不使用命名方式
end

--添加数据
function o:AddMsg(data)
    if data.chanType == BROADCAST_TYPE.ROOM_TYPE then
        print("CChatCtrl","触发事件")
        self:TriggerEvent(EventDefine.CTRL_EVENT.RoomMsg,data)
    end
end
return o