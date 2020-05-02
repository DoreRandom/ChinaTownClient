local protobuf = require "logic.net.protobuf"
local M = {}
M.ProtoPath = "ChinaTown/Proto/proto.pb"

function M.Init()
    local textAsset = g_ResCtrl:GetAssetFromCache(M.ProtoPath)
    protobuf.register(textAsset.bytes)
end

--[[
    len 2
    cmd 4
    seq 4
    msg 

    --格式说明
	--> >:big endian
	-->I2:前面两位为长度
	-->I4:uint32 
    -->I4:uint32 
]]
function M.Serialize(cmd,seq,obj)
    local cmdCode = NetDefine.C2GSByName[cmd]
    if not cmdCode then
        error("netproto.Serialize: has no cmd ",cmd)
    end
    seq = seq or 0
    local msg = protobuf.encode(cmd,obj)
    local msgLength = string.len(msg)
    local length = msgLength + 8
    local p = "> I2 I4 I4 c" .. msgLength
    return string.pack(p,length,cmdCode,seq,msg)
end

--[[
    cmd 4
    seq 4
    msg 
]]
function M.Deserialize(data,length)
    length = length or string.len(data)
    local msgLength = length - 8 --数据长度
    local p = "> I4 I4 c" .. msgLength
    local cmdCode,seq,msg = string.unpack(p,data)
    local m = NetDefine.GS2C[cmdCode]
    if not m then
        error("netproto.Deserialize: has no code ",cmdCode)
    end
    local obj = protobuf.decode(m.cmd,msg)
    return m.mod,m.cmd,seq,obj
end


return M