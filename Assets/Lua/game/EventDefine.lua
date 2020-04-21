local t = {}

t.CURSOR_EVENT = {
    PutShop = 1,
    Trade = 2,
    Signal = 3
}

t.CTRL_EVENT = {
    --AttrCtrl
    SetPlayerInfo = 1,
    --ChatCtrl
    RoomMsg = 101,
    --GameCtrl 
    RefreshPlayerStatus = 201
}
return t