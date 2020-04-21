local CDelayCallBase = class("CDelayCallBase")

function CDelayCallBase.ctor(self)
	self.m_DelayCallTimerDict = nil
	self.m_IsIgnoreTimescale = true
end

function CDelayCallBase.DelayCall(self, time, funcname, ...)
	if not self.m_DelayCallTimerDict then
		self.m_DelayCallTimerDict = {}
	end
	local timer = self.m_DelayCallTimerDict[funcname]
	if timer then
		Utils.DelTimer(timer)
	end
	if self.m_IsIgnoreTimescale then
		self.m_DelayCallTimerDict[funcname] = Utils.AddTimer(callback(self, funcname, ...), time, time)
	else
		self.m_DelayCallTimerDict[funcname] = Utils.AddScaledTimer(callback(self, funcname, ...), time, time)
	end
end

function CDelayCallBase.TimerCall(self,delta,delay, funcname, ...)
	if not self.m_DelayCallTimerDict then
		self.m_DelayCallTimerDict = {}
	end
	local timer = self.m_DelayCallTimerDict[funcname]
	if timer then
		Utils.DelTimer(timer)
	end
	if self.m_IsIgnoreTimescale then
		self.m_DelayCallTimerDict[funcname] = Utils.AddTimer(callback(self, funcname, ...), delta, delay)
	else
		self.m_DelayCallTimerDict[funcname] = Utils.AddScaledTimer(callback(self, funcname, ...), delta, delay)
	end
end

function CDelayCallBase.DelayCallNotReplace(self, time, funcname, ...)
	if not self.m_DelayCallTimerDict then
		self.m_DelayCallTimerDict = {}
	end
	local timer = self.m_DelayCallTimerDict[funcname]
	if not timer then
		if self.m_IsIgnoreTimescale then
			self.m_DelayCallTimerDict[funcname] = Utils.AddTimer(callback(self, funcname, ...), time, time)
		else
			self.m_DelayCallTimerDict[funcname] = Utils.AddScaledTimer(callback(self, funcname, ...), time, time)
		end
	end
end

--停止调用延迟回调
function CDelayCallBase.StopDelayCall(self, funcname)
	if not self.m_DelayCallTimerDict then
		return
	end
	local timer = self.m_DelayCallTimerDict[funcname]
	if timer then
		Utils.DelTimer(timer)
		self.m_DelayCallTimerDict[funcname] = nil
	end
end

return CDelayCallBase