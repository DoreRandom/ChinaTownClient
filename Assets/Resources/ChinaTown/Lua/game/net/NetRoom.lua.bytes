local M = {}
--GS2C--
function M.GS2CAddRoom(ndata)
    g_RoomCtrl:AddRoom(ndata)
end

function M.GS2CDelRoom(ndata)
    g_RoomCtrl:DelRoom()
end

function M.GS2CAddRoomMember(ndata)
    g_RoomCtrl:AddRoomMember(ndata.memInfo)
end

function M.GS2CChangeLeader(ndata)
    g_RoomCtrl:ChangeLeader(ndata.leader)
end

function M.GS2CRefreshRoomStatus(ndata)
    g_RoomCtrl:RefreshRoomStatus(ndata.roomStatus)
end

function M.GS2CRefreshMemberInfo(ndata)
    g_RoomCtrl:RefreshMemberInfo(ndata.memInfo)
end

--C2GS--
function M.C2GSCreateRoom()
    local t = {}
    g_NetCtrl:Send("Room","C2GSCreateRoom",t)
end

function M.C2GSJoinRoom(roomId)
    local t = {
        roomId = roomId
    }
    g_NetCtrl:Send("Room","C2GSJoinRoom",t)
end

function M.C2GSKickRoom(targetPid)
    local t = {
        targetPid = targetPid
    }
    g_NetCtrl:Send("Room","C2GSKickRoom",t)
end

function M.C2GSLeaveRoom()
    local t = {}
    g_NetCtrl:Send("Room","C2GSLeaveRoom",t)
end

function M.C2GSSetReady(ready)
    local t = {
        ready = ready
    }
    g_NetCtrl:Send("Room","C2GSSetReady",t)
end

function M.C2GSStartGame()
    local t = {}
    g_NetCtrl:Send("Room","C2GSStartGame",t)
end

return M