local M = {}

function M.GS2CRefreshPlayer(ndata)
    g_AttrCtrl:GS2CRefreshPlayer(ndata)
end

--返回房间
function M.C2GSBackToTeam()
    local t = {
    }
    g_NetCtrl:Send("Player","C2GSBackToTeam",t)
end
--返回大厅
function M.C2GSBackToHall()
    local t = {
    }
    g_NetCtrl:Send("Player","C2GSBackToHall",t)
end

return M