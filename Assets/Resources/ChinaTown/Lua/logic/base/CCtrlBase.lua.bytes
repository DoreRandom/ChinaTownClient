--Ctrl基类
--主要用于管理事件
local o = class("CCtrlBase")

function o.ctor(self)
    self.m_EventMap = {}
end

function o:AddEvent(obj,eventType,func)
    local key = tostring(obj)
    if not self.m_EventMap[eventType] then
        self.m_EventMap[eventType] = {}
    end
    self.m_EventMap[eventType][key] = func
end

function o:DelEvent(obj,eventType)
    local key = tostring(obj)
    if self.m_EventMap[eventType] then
        self.m_EventMap[eventType][key] = nil
    end
end

function o:TriggerEvent(eventType,data)
    local m = self.m_EventMap[eventType]
    if m then
        for k,f in pairs(m) do
            f(eventType,data)
        end
    end
end

function o:ClearEvent()
    self.m_EventMap = {}
end

return o