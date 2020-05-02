local M = {}

--GS2C--
function M.GS2CHeartBeat(ndata)
    g_ServerTimeCtrl:ServerHeartBeat(ndata.time)
end

function M.GS2CNotify(ndata)
    if ndata.window then
        CNotifyView.Notify("",ndata.msg)
    else
        print(ndata.msg)
    end
end


--C2GS--

function M.C2GSHeartBeat()
    local t = {
    }
    g_NetCtrl:Send("Other","C2GSHeartBeat",t)
end


return M