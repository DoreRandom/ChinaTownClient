require "game.gamemain.gamemain"
require "game.login.login"
require "game.home.home"
require "game.ui.ui"
require "game.data.data"
require "game.scene.scene"
require "game.cross.cross"
require "game.net.net"

EventDefine = require "game.EventDefine"


g_GameCtrl = CGameCtrl.New()
g_LoginCtrl = CLoginCtrl.New()
g_AttrCtrl = CAttrCtrl.New()
g_RoomCtrl = CRoomCtrl.New()
g_ChatCtrl = CChatCtrl.New()
g_ServerTimeCtrl = CServerTimeCtrl.New()
