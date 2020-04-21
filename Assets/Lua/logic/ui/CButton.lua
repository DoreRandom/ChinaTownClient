--用于拓展ugui button的方法
local CButton = {}

function CButton.New(button)
    local o = {}
    setmetatable(o,{
        __index = function (t,k)
            local ret = CButton[k]
            if ret then return ret end
            return button[k]
        end
    })
    o.m_ClickSoundPath  = ChinaTownRes.sound.clickPath

    o.onClick:AddListener(function ()
        g_AudioCtrl:Play(o.m_ClickSoundPath)    
    end)

    return o
end

--设置点击声音路径
function CButton:SetClickSoundPath(path)
    self.m_ClickSoundPath = path
end

return CButton



