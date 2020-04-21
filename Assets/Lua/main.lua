main = {}
main.g_IsInitDone = false

--C# 回调
function main.start()
	main.InitEnv()

	local function check()
		if g_ResCtrl:IsInitDone() and main.g_IsInitDone then
			main.StartGame()
			return
		end
		return true
	end
	Utils.AddTimer(check,0,0)

end

function main.update( dt )

	local iUnScaleTime = (dt / UnityEngine.Time.timeScale)
	UnityEngine.Time:SetDeltaTime(dt, iUnScaleTime)
	
	g_TimerCtrl:Update() --定时器
	g_NetCtrl:Update()
	g_UIEffectCtrl:Update()
	UnityEngine.Time:SetFrameCount()
end

function main.lateupdate( dt )
	g_TimerCtrl:LateUpdate() --定时器
end

function main.pause(bPaused, iPausetime)
	
end

function main.onApplicationQuit()
	g_NetCtrl:Dispose()
	g_TimerCtrl:Release()
end

--C# 回调结束
function main.RequireModule(  )
	require "preload.preload"	
	require "logic.logic"
	require "game.game"
end

--初始化环境
function main.InitEnv()
	main.RequireModule()

	--对初始化的资源进行加载
	g_ResCtrl:InitLoad()

	CSettingView:ShowView()
	CNotifyView:ShowView()
	CLoadingView:ShowView()
	
	main.g_IsInitDone = true  --完成初始化
end

--开始游戏
function main.StartGame()	
	--protobuf添加文件
	NetProto.Init()
	g_SceneCtrl:SwitchScene(SLogin)
end


return main

