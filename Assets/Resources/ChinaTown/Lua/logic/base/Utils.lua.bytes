g_Platform = UnityEngine.Application.platform:GetHashCode()
g_UniqueID = 1000 --预留1000个特殊id

--递增不重复id
function GetUniqueID()
	g_UniqueID = g_UniqueID  + 1
	return g_UniqueID
end

--定时器相关
function TimerAssert(sType, cbfunc, delta, delay)
	assert(cbfunc and delta and delay, sType.." args error!!!")
	assert(delta >= 0, sType.." delta must > 0")
	assert(delay >= 0, sType.." delay must > 0")
end

--添加和删除定时器
-- Update
function AddTimer(cbfunc, delta, delay)
	TimerAssert("AddTimer", cbfunc, delta, delay)
	return g_TimerCtrl:AddTimer(cbfunc, delta, delay, true, false)
end

function AddScaledTimer(cbfunc, delta, delay)
	TimerAssert("AddScaledTimer", cbfunc, delta, delay)
	return g_TimerCtrl:AddTimer(cbfunc, delta, delay, false, false)
end

-- LaterUpdate
function AddLateTimer(cbfunc, delta, delay)
	TimerAssert("AddLateTimer", cbfunc, delta, delay)
	return g_TimerCtrl:AddTimer(cbfunc, delta, delay, true, true)
end

function AddScaledLateTimer(cbfunc, delta, delay)
	TimerAssert("AddScaledLateTimer", cbfunc, delta, delay)
	return g_TimerCtrl:AddTimer(cbfunc, delta, delay, false, true)
end

function DelTimer(timerid)
	g_TimerCtrl:DelTimer(timerid)
end

--定时器end

function IsNil(o)
	if not o then
		return true
	end
	if type(o) == "userdata" and o.Equals ~= nil then
		return o:Equals(nil)
	end
	return false
end

function IsExist(t)
	return not IsNil(t)
end

function IsEditor()
	return g_Platform == 0 or g_Platform == 7
end

return _G