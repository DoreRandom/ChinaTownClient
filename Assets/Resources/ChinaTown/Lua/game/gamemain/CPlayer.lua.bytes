local o = class("CPlayer")
--todo 这里暂时不进行命名规范
function o:ctor(data)
    self.pid = data.pid
    self.name = data.name
    self.head = data.head
    self.color = data.color
    self.status = data.status
end

--获得名字状态地结合
function o:GetName()
    local ret = self.name 
    if self.status.online ~= 0 then
        ret  = ret .. "(离线)"
    end
    return ret
end


return o