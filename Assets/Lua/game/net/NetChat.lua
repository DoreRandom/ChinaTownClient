local M = {}

--GS2C--
function M.GS2CChat(ndata)
    g_ChatCtrl:AddMsg(ndata)
end

--C2GS--

function M.C2GSChat(chanType,msg)
    local t = {
        msg = msg,
        chanType = chanType
    }
    g_NetCtrl:Send("Chat","C2GSChat",t)
end

return M