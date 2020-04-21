local M = {}

--GS2C--
function M.GS2CRegisterResult(ndata)
    CNotifyView.Notify("提示",ndata.retMsg)
end

function M.GS2CLoginResult(ndata)
    if ndata.retCode ~= ERROR_CODE.Ok then
        CNotifyView.Notify("提示",ndata.retMsg)
    else
        g_LoginCtrl:LoginSuccess(ndata)
    end
end

--C2GS--

function M.C2GSLogin(account,password)
    local t = {
        account = account,
        password = password
    }
    g_NetCtrl:Send("Verify","C2GSLogin",t)
end

function M.C2GSRegister(account,password)
    local t = {
        account = account,
        password = password
    }
    g_NetCtrl:Send("Verify","C2GSRegister",t)
end

return M