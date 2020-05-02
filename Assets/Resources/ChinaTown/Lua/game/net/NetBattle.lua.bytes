local M = {}

--GS2C--
function M.GS2CCreateBattle(ndata)
    g_GameCtrl:CreateBattle(ndata)
end

function M.GS2CRefreshYear(ndata)
    g_GameCtrl:RefreshYear(ndata)
end

function M.GS2CDispatchCard(ndata)
    g_GameCtrl:DispatchCard(ndata)
end

function M.GS2CRefreshLocation(ndata)
    g_GameCtrl:RefreshLocation(ndata)
end

function M.GS2CRefreshPlayerStatus(ndata)
    g_GameCtrl:RefreshPlayerStatus(ndata)
end

function M.GS2CSelectCard(ndata)
    g_GameCtrl:SelectedCard(ndata)
end

function M.GS2CSignal(ndata)
    g_GameCtrl:OnSignal(ndata)
end

function M.GS2CTrade(ndata)
    g_GameCtrl:Trade(ndata)
end

function M.GS2CRefreshTradeInfo(ndata)
    g_GameCtrl:RefreshTradeInfo(ndata)
end

function M.GS2CRankInfo(ndata)
    g_GameCtrl:RankInfo(ndata)
end

--C2GS--
--显示缓存的窗口
function M.C2GSShowCacheWindow()
    local t = {
        bid = g_GameCtrl:GetBid()
    }
    g_NetCtrl:Send("Battle","C2GSShowCacheWindow",t)
end
--选择卡牌
function M.C2GSSelectCard(shopList,locationList)
    local t = {
        bid = g_GameCtrl:GetBid(),
        shopList = shopList,
        locationList = locationList
    }
    g_NetCtrl:Send("Battle","C2GSSelectCard",t)
end
--下一年
function M.C2GSNextYear()
    local t = {
        bid = g_GameCtrl:GetBid()
    }
    g_NetCtrl:Send("Battle","C2GSNextYear",t)
end
--发送信号
function M.C2GSSignal(x,y)
    local t = {
        bid = g_GameCtrl:GetBid(),
        x = x,
        y = y
    }
    g_NetCtrl:Send("Battle","C2GSSignal",t)
end
--设置店铺
function M.C2GSSetShopToLocation(lid,shop)
    local t = {
        bid = g_GameCtrl:GetBid(),
        lid = lid,
        shop = shop
    }
    g_NetCtrl:Send("Battle","C2GSSetShopToLocation",t)
end
--发起交易
function M.C2GSTrade(targetPid)
    local t = {
        bid = g_GameCtrl:GetBid(),
        targetPid = targetPid
    }
    g_NetCtrl:Send("Battle","C2GSTrade",t)
end
--取消交易
function M.C2GSCancelTrade()
    local t = {
        bid = g_GameCtrl:GetBid()
    }
    g_NetCtrl:Send("Battle","C2GSCancelTrade",t)
end
--交易店铺
function M.C2GSTradeShop(shop,num)
    local t = {
        bid = g_GameCtrl:GetBid(),
        tid = g_GameCtrl:GetTid(),
        shop = shop,
        num = num
    }
    g_NetCtrl:Send("Battle","C2GSTradeShop",t)
end
--交易地
function M.C2GSTradeLocation(lid)
    local t = {
        bid = g_GameCtrl:GetBid(),
        tid = g_GameCtrl:GetTid(),
        lid = lid
    }
    g_NetCtrl:Send("Battle","C2GSTradeLocation",t)
end
--交易钱
function M.C2GSTradeMoney(money)
    local t = {
        bid = g_GameCtrl:GetBid(),
        tid = g_GameCtrl:GetTid(),
        money = money
    }
    g_NetCtrl:Send("Battle","C2GSTradeMoney",t)
end
--交易锁
function M.C2GSTradeLock()
    local t = {
        bid = g_GameCtrl:GetBid(),
        tid = g_GameCtrl:GetTid(),
    }
    g_NetCtrl:Send("Battle","C2GSTradeLock",t)
end
--退出
function M.C2GSForceLeave()
    local t = {

    }
    g_NetCtrl:Send("Battle","C2GSForceLeave",t)
end
return M