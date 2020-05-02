--用于同步服务器时间 心跳
local o = class("CServerTimeCtrl",CDelayCallBase)

local HERTBEAT_TIME = 10
local HERTBEAT_OUTTIME = 60

function o:ctor()
    self.m_LocalTimeSinceStartUp = CS.UnityEngine.Time.realtimeSinceStartup
    self.m_ServerTime = 0
end

--周期发送心跳包
function o:HeartBeat()
    print("HeartBeat")
    if not g_NetCtrl:IsConnected() then
        self:StopHeartBeat()
        return false
    end
    NetOther.C2GSHeartBeat()
    self:DelayCallNotReplace(HERTBEAT_OUTTIME,"HeartBeatTimeOut")
    return true
end
--收到服务端的心跳包
function o:ServerHeartBeat(time)
    self.m_LocalTimeSinceStartUp = CS.UnityEngine.Time.realtimeSinceStartup
    self.m_ServerTime = time
    self:StopDelayCall("HeartBeatTimeOut")
    print("同步服务器时间",self:Convert(time))
end
--心跳包超时处理
function o:HeartBeatTimeOut()
    print("CServerTimeCtrl:HeartBeatTimeOut 超时")
    self:StopHeartBeat()
    g_NetCtrl:Reconnect()
end
--开始心跳包
function o:StartHeartBeat()
    self:StopHeartBeat()
    self:TimerCall(HERTBEAT_TIME,0,"HeartBeat")
end
--停止心跳包
function o:StopHeartBeat()
    self:StopDelayCall("HeartBeat")
    self:StopDelayCall("HeartBeatTimeOut")
end
--时间转换
function o:Convert(seconds)
	return os.date("%Y/%m/%d %H:%M:%S", seconds)
end
return o