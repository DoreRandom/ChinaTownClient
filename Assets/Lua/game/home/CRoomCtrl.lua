--用于记录和更新房间信息
local o = class("CRoomCtrl",CCtrlBase)

function o:ctor()
    CCtrlBase.ctor(self)
    self.m_RoomId = nil
    self.m_Leader = nil
    self.m_Members = nil
    self.m_Init = false
end

function o:IsLeader(pid)
    return self.m_Leader == pid
end

function o:LocalIsLeader()
    return g_AttrCtrl:GetPid() == self.m_Leader
end

function o:GetLeader()
    return self.m_Leader
end

function o:GetRoomId()
    return self.m_RoomId
end
--加入房间
function o:AddRoom(data)
    self.m_RoomId = data.roomId
    self.m_Leader = data.leader
    self.m_Members = data.members
    self.m_Init = true
    CRoomChatView:ShowView()
    CJoinRoomView:CloseView()
    self:RefreshView()
end

--移除房间
function o:DelRoom()
    self.m_RoomId = nil
    self.m_Leader = nil
    self.m_Members = nil
    self.m_Init = false
    CRoomView:CloseView()
    CRoomChatView:CloseView()
end

--添加成员
function o:AddRoomMember(memInfo)
    table.insert(self.m_Members,memInfo)
end

--更改leader
function o:ChangeLeader(leader)
    self.m_Leader = leader
    self:RefreshView()
end

--更新房间状态
function o:RefreshRoomStatus(roomStatus)
    local members = {}
    for _,pid in ipairs(roomStatus) do
        local mem = self:GetMemberByPid(pid)
        table.insert(members,mem)
    end
    self.m_Members = members
    self:RefreshView()
end

--更新成员信息
function o:RefreshMemberInfo(memInfo)
    for i,mem in ipairs(self.m_Members) do
        if mem.pid == memInfo.pid then
            self.m_Members[i] = memInfo
            self:RefreshView()
            break
        end
    end
end

--更新view
function o:RefreshView()
    if not self.m_Init then return end
    CRoomView:ShowView(function (view)
        view:Show()
    end)
end

--离开房间
function o:LeaveRoom()
    self.m_Init = false
end

function o:GetMember(pos)
    return self.m_Members[pos]
end

function o:GetMemberByPid(pid)
    for i,mem in ipairs(self.m_Members) do
        if mem.pid == pid then
            return mem
        end
    end
end
--获得角色位置
function o:GetMemberIndex(pid)
    for i,mem in ipairs(self.m_Members) do
        if mem.pid == pid then
            return i
        end
    end
end

function o:GetMembers()
    return self.m_Members
end

return o