local M = {}

--GS2C--
function M.GS2CLoginAccount(ndata)
    g_LoginCtrl:LoginAccountSuccess(ndata)
end

function M.GS2CLoginPlayer(ndata)
    g_LoginCtrl:SetPlayerToken(ndata.playerToken)
    g_AttrCtrl:SetPlayerInfo(ndata.player)
    g_ServerTimeCtrl:StartHeartBeat()
    g_SceneCtrl:SwitchScene(SHome)
end

function M.GS2CCreatePlayer(ndata)
    g_LoginCtrl:CreatePlayerSuccess(ndata)
end

function M.GS2CLoginError(ndata)
    g_LoginCtrl:LoginModError(ndata)
end

--C2GS--

function M.C2GSLoginAccount(account,token)
    local t = {
        account = account,
        token = token
    }
    g_NetCtrl:Send("Login","C2GSLoginAccount",t)
end

function M.C2GSCreatePlayer(name,head)
    local t = {
        name = name,
        head = head
    }
    g_NetCtrl:Send("Login","C2GSCreatePlayer",t)
end

function M.C2GSLoginPlayer(pid)
    local t = {
        pid = pid
    }
    g_NetCtrl:Send("Login","C2GSLoginPlayer",t)
end

function M.C2GSReLoginPlayer(pid,playerToken)
    local t = {
        pid = pid,
        playerToken = playerToken
    }
    g_NetCtrl:Send("Login","C2GSReLoginPlayer",t)
end

return M