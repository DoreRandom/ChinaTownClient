--游戏
local o = class("CGameCtrl",CCtrlBase)

local Colors = {
    "#DC143C", --红
    "#87CEEB", --蓝
    "#FFD700", --黄
    "#90EE90", --绿
    "#BA55D3", --紫
}
function o:ctor()
    CCtrlBase.ctor(self)
    self.m_Pid = nil --本地pid
    self.m_Bid = 0
    self.m_Tid = 0
    self.m_Players = {}
end
--获得本地pid
function o:GetLocalPid()
    return self.m_Pid
end
--获得本地player
function o:GetLocalPlayer()
    return self:GetPlayer(self.m_Pid)
end
--获得bid
function o:GetBid()
    return self.m_Bid
end
--获得tid
function o:GetTid()
    return self.m_Tid
end
--获得玩家信息
function o:GetPlayers()
    return self.m_Players
end
--获得玩家信息
function o:GetPlayer(pid)
    for _,player in ipairs(self.m_Players) do
        if player.pid == pid then
            return player
        end
    end
end
--获得玩家数量
function o:GetPlayerCount()
    return #self.m_Players
end

--处理网络 start
--创建对战
function o:CreateBattle(data)
    self.m_Pid = g_AttrCtrl:GetPid()
    self.m_Bid = data.bid
    
    self.m_Players= {}
    local index = 1
    for _,info in ipairs(data.playerInfos) do
        local color = Colors[index] --TODO 这里由客户端选择颜色
        info.color = color
        table.insert(self.m_Players,CPlayer.New(info))
        index = index + 1
    end
    g_RoomCtrl:LeaveRoom()
    g_SceneCtrl:SwitchScene(SGameMain)
end
--更新用户状态
function o:RefreshPlayerStatus(data)
    assert(data.bid == self.m_Bid,"非同一场战斗")
    local player = self:GetPlayer(data.pid)
    for k,v in pairs(data.status) do
        player.status[k] = v
    end 
    self:TriggerEvent(EventDefine.CTRL_EVENT.RefreshPlayerStatus,data)
end
--发卡
function o:DispatchCard(data)
    assert(data.bid == self.m_Bid,"非同一场战斗")
    CSelectionView:ShowView(function (view)
        view:SetSelections(data)
    end)
end
--更新年份
function o:RefreshYear(data)
    assert(data.bid == self.m_Bid,"非同一场战斗")
    CYearView:ShowView(function (view)
        view:RefreshYear(data)
    end)
end
--更新地
function o:RefreshLocation(data)
    assert(data.bid == self.m_Bid,"非同一场战斗")
    CGameView:ShowView(function (view)
        view:RefreshLocation(data)
    end)
end
--已经选择卡牌
function o:SelectedCard(data)
    assert(data.bid == self.m_Bid,"非同一场战斗")
    CSelectionView:CloseView()
end
--收到信号
function o:OnSignal(data)
    assert(data.bid == self.m_Bid,"非同一场战斗")
    local view = COptionView:GetView()
    if view then
        COptionView:OnSignal(data)
    end
end
--交易窗口
function o:Trade(data)
    assert(data.bid == self.m_Bid,"非同一场战斗")
    self.m_Tid = data.tid
    if data.tid == 0 then
        CTradeView:CloseView()
    else
        CTradeView:ShowView(function (view)
            view:SetTrade(data)
        end)
    end
end
--交易信息更新
function o:RefreshTradeInfo(data)
    assert(data.bid == self.m_Bid,"非同一场战斗")
    local view = CTradeView:GetView()
    if view then
        view:RefreshTradeInfo(data)
    end
end
--排名信息
function o:RankInfo(data)
    assert(data.bid == self.m_Bid,"非同一场战斗")
    CRankView:ShowView(function (view)
        view:ShowRank(data)
    end)
end

--处理网络 end
--获得玩家序号
function o:GetPlayerIndex(pid)
    --首先进行排序
    local l = {}
    for _,v in pairs(self.m_Players) do
        if self:IsLocal(v.pid) then
            table.insert(l,v)
        end
    end
    for _,v in pairs(self.m_Players) do
        if not self:IsLocal(v.pid) then
            table.insert(l,v)
        end
    end

    for index,player in ipairs(l) do
        if player.pid == pid then
            return index
        end
    end
    assert(false,"找不到该玩家")
end
--判断是否为当前用户
function o:IsLocal(pid)
    return self.m_Pid == pid
end
--获得玩家颜色
function o:GetPlayerColor(pid)
    local player = self:GetPlayer(pid)
    return Color.ParseHtmlString(player.color)
end

return o