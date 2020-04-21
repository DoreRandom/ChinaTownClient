classtype = require "logic.classtype"

require "logic.base.base"
require "logic.ui.ui"
require "logic.scene.scene"
require "logic.net.net"
--base
g_TimerCtrl = CTimerCtrl.New() --定时器模块
g_ResCtrl = CResCtrl.New()
g_AudioCtrl = CAudioCtrl.New()

--ui
g_ViewCtrl = CViewCtrl.New()
g_UIEffectCtrl = CUIEffectCtrl.New()

--scene
g_SceneCtrl = CSceneCtrl.New()

--net
g_NetCtrl = CNetCtrl.New()
