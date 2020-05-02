local o = class("CLoginCtrl",CCtrlBase)

local server = {
    ip = "47.114.32.38",
    port = 12345
}

function o:ctor()
    CCtrlBase.ctor(self)

    self.m_LoginInfo = nil --登陆信息
    self.m_Reconnect = false --是否在重连
    --verify 
    self.m_Account = nil
    self.m_AccountToken = nil
    self.m_Pid = nil
    self.m_PlayerToken = nil
end

function o:CleanUp()
    self.m_Account = nil
    self.m_AccountToken = nil
    self.m_Pid = nil
    self.m_PlayerToken = nil
end

function o:SetPlayerToken(playerToken)
    self.m_PlayerToken = playerToken
end

function o:GetLoginInfo()
    return self.m_LoginInfo
end
--ui
--设置登陆信息
function o:LoginServer(account,pwd,isReg)
    self.m_LoginInfo = {account = account,pwd = pwd,isReg = isReg}
    if g_NetCtrl:IsConnecting() then
        print("CLoginCtrl:LoginServer","正在连接服务器")
    elseif g_NetCtrl:IsConnected() then
        self:LoginRequest()
    else
        g_NetCtrl:Connect(server.ip,server.port,
        callback(self,"OnConnect"),callback(self,"OnClose"))
    end
end

--verify start
--发送login请求
function o:LoginRequest()
    if not self.m_LoginInfo then
        return 
    end
    if self.m_LoginInfo.isReg then
        NetVerify.C2GSRegister(self.m_LoginInfo.account,self.m_LoginInfo.pwd)
    else
        NetVerify.C2GSLogin(self.m_LoginInfo.account,self.m_LoginInfo.pwd)
    end
end

--登陆成功
function o:LoginSuccess(data)
    self.m_Account = data.account
    self.m_AccountToken = data.token

    --进行账号登陆，获得角色列表
    NetLogin.C2GSLoginAccount(self.m_Account,self.m_AccountToken)
end

--verify end

--login
function o:LoginAccountSuccess(data)
    if data.account ~= self.m_Account then
        return 
    end
    if data.playerList == nil or #data.playerList == 0 then
        CCreatePlayerView:ShowView()
    else

        local ins = data.playerList[1]
        self.m_Pid = ins.pid
        NetLogin.C2GSLoginPlayer(self.m_Pid)
    end
end


--创建玩家成功
function o:CreatePlayerSuccess(data)
    CCreatePlayerView:CloseView()
    local ins = data.player
    self.m_Pid = ins.pid
    NetLogin.C2GSLoginPlayer(self.m_Pid)
end

function o:LoginModError(data)
    local code = data.retCode
    local msg = data.retMsg
    if code == ERROR_CODE.Common then
        CNotifyView.Notify("提示",msg)
    elseif code == ERROR_CODE.Token then
        print("CLoginCtrl:LoginModError token 失效处理")
    elseif code == ERROR_CODE.InvalidPlayerToken then
        g_SceneCtrl:SwitchScene(SLogin)
    end
end
--login end

function o:OnConnect()
    print("CLoginCtrl:OnConnect " .. server.ip .. ",port: " .. server.port)
    if self.m_Reconnect and self.m_Pid and self.m_PlayerToken then
        self.m_Reconnect = false
        NetLogin.C2GSReLoginPlayer(self.m_Pid,self.m_PlayerToken)
    else
        self:LoginRequest()
    end
end

function o:OnClose()
    CNotifyView.Notify("","与服务器断开连接,是否重连", { 
        [1] = {text = "确定",cb = callback(self,"Reconnect")},
        [2] = {text = "取消",cb = callback(self,"CancelReconnect")}
    })
end

function o:Reconnect()
    self.m_Reconnect = true
    g_NetCtrl:Reconnect()
end

function o:CancelReconnect()
    CS.UnityEngine.Application.Quit()
end

return o