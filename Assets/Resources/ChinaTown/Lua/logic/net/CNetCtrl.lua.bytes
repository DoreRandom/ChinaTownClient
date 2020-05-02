local o = class("CNetCtrl",CCtrlBase,CDelayCallBase)

local CONNECT_TIME_OUT = 15

function o.ctor(self)
    CCtrlBase.ctor(self)
    CDelayCallBase.ctor(self)
    self.m_Socket = nil
    self.m_RequestSeq = 1
    self.m_Host = nil
    self.m_Port = nil
    self.m_MsgQueue = {}
    self.m_MsgSuspend = false
end
--设置是否为暂停处理消息
function o:SetSubspend(subspend)
    self.m_MsgSuspend = subspend
end

function o:OnReceive(bytes)
    local mod,cmd,seq,obj = NetProto.Deserialize(bytes)
    print("<<<<<<",mod,cmd,seq,table_tostring(obj))
    local msg = {
        mod = mod,
        cmd = cmd,
        seq = seq,
        obj = obj
    }
    table.insert(self.m_MsgQueue,msg)
end

function o:Send(mod,cmd,obj)
    print(">>>>>>",mod,cmd,table_tostring(obj))
    local data = NetProto.Serialize(cmd,self.m_RequestSeq,obj)
    self.m_Socket:SendMessage(data)
    self.m_RequestSeq=self.m_RequestSeq+1
end

--[[
    开发日志:
    这里如果对socket进行复用而非新建一个，会出现收不到包等问题，初步判断为底层实现有bug。因c# socket库来自第三方，因此暂且回避
]]
function o:Connect(host,port,onConnect,onClose)
    
    self.m_Socket = CS.Networks.HjTcpNetwork()
    self.m_Socket.ReceivePkgHandle = callback(self,"OnReceive")
    
    self.m_Socket.OnConnect = function ()
        self:StopDelayCall("ConnectTimeOut")
        self.m_MsgQueue = {}
        self.m_CallClose = true
        
        onConnect()
    end
    self.m_Socket.OnClosed = function ()
        self:StopDelayCall("ConnectTimeOut")
        g_ServerTimeCtrl:StopHeartBeat()
        self.m_MsgQueue = {}
        
        if self.m_CallClose then
            self.m_CallClose = false
            onClose()
        end
    end
    self.m_CallClose = false
    self.m_Host = host
    self.m_Port = port
    self.m_OnConnect = onConnect
    self.m_OnClose = onClose
    self.m_Socket:SetHostPort(host,port)
    self.m_Socket:Connect()
    print("CNetCtrl:Connect to "..host..", port : "..port)

    self:DelayCallNotReplace(CONNECT_TIME_OUT,"ConnectTimeOut")
    return self.m_Socket
end

function o:Reconnect()
    if self:IsConnected() or self:IsConnecting() then return end

    self:Connect(self.m_Host,self.m_Port,self.m_OnConnect,self.m_OnClose)
    print("CNetCtrl:Reconnect to "..self.m_Host..", port : "..self.m_Port)

    self:DelayCallNotReplace(CONNECT_TIME_OUT,"ConnectTimeOut")
end

function o:SetCallClose(callclose)
    self.m_CallClose = callclose
end

function o:IsConnected()
    if not self.m_Socket then
        return false
    end
    return self.m_Socket:IsConnected()
end

function o:IsConnecting()
    if not self.m_Socket then
        return false
    end
    return self.m_Socket:IsConnecting()
end

function o:Update()
    if self.m_Socket then
        self.m_Socket:UpdateNetwork()
        self:DispatchMsg()
    end
end

--处理消息
function o:DispatchMsg()
    while #self.m_MsgQueue >=1 and not self.m_MsgSuspend do
        local msg =  self.m_MsgQueue[1]
        table.remove(self.m_MsgQueue,1)
        local mod,cmd,seq,obj = msg.mod,msg.cmd,msg.seq,msg.obj
        local m = _G["Net"..mod]
        if m then
            local f = m[cmd]
            if f then
                f(obj)
                return 
            end
        end
        print(string.format("CNetCtrl:DispatchMsg mod %s cmd %s not exist ",mod,cmd))
    end
end

function o:Disconnect()
    if self.m_Socket then
        self.m_Socket:Close()
    end
end

function o:Dispose()
    if self.m_Socket then
        self.m_Socket:Dispose()
    end
    self.m_Socket = nil
end

function o:ConnectTimeOut()
    self:Disconnect()
end

return o