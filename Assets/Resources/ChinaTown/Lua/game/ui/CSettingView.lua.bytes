local o = class("CSettingView",CViewBase)

o.Config = {
    PrefabPath = "ChinaTown/UI/Common/SettingView",
    Layer = UILayers.TipLayer,
    Recycle = true,
    KeepOnSwitch = true
}

local Resolutions = {
    "1920X1080",
    "1600X900",
    "1280X720"
}

function o.ctor(self,cb)
    CViewBase.ctor(self, cb)
    self.m_PrefabPath = o.Config.PrefabPath
    self.m_Layer = o.Config.Layer
    self.m_Recycle = o.Config.Recycle
end

function o.OnCreateView(self)
    self.m_SettingGroup = self:GetGameObject(1)
    self.m_ResolutionDropDown = self:GetUI(2,UIDropdown)
    self.m_FullScreenToggle = self:GetUI(3,UIToggle)
    self.m_VolumeSlider = self:GetUI(4,UISlider)
    self.m_VolumeText = self:GetUI(5,UIText)
    self.m_ConfirmBtn = self:GetUI(6,UIButton)

    --添加分辨率选项
    self.m_ResolutionDropDown:ClearOptions();

    local list = CS.XLuaHelper.CreateListInstance(typeof(CS.System.String))

    for i,v in ipairs(Resolutions) do
        list:Add(v)
    end

    self.m_ResolutionDropDown:AddOptions(list)

    --分辨率
    local resolution = ClientData.Get("Resolution","1280X720")
    for i,v in ipairs(Resolutions) do
        if v==resolution then
            self.m_ResolutionDropDown.value = i-1
        end
    end
    --全屏
    local fullscreen = ClientData.Get("FullScreen","0")
    if (tonumber(fullscreen) == 0) then
        fullscreen = false
    else
        fullscreen = true
    end
    self.m_FullScreenToggle.isOn = fullscreen
    --音量
    local volume = ClientData.Get("Volume","100")
    self.m_VolumeText.text = volume
    volume = tonumber(volume)
    self.m_VolumeSlider.value = volume / 100
    


    self.m_ResolutionDropDown.onValueChanged:AddListener(function (n)
        self:SetScreen()
    end)

    self.m_FullScreenToggle.onValueChanged:AddListener(function (n)
        self:SetScreen()
    end)

    self.m_VolumeSlider.onValueChanged:AddListener(function (n)
        self:SetVolume()
    end)

    self.m_ConfirmBtn.onClick:AddListener(function ()
        self:OnClickConfirm()
    end)
end

--窗口激活后调用
function o:OnShowView()
    self:DelayCall(0,"Update")

end

--隐藏后调用
function o:OnHideView()
    self:StopDelayCall("Update")
end


--设置屏幕相关
function o:SetScreen()
    --分辨率
    local resolution = Resolutions[self.m_ResolutionDropDown.value + 1]
    local list = string.split(resolution,"X")
    local width,height = tonumber(list[1]),tonumber(list[2])

    --全屏
    local fullscreen = self.m_FullScreenToggle.isOn
    CS.UnityEngine.Screen.SetResolution(width,height,fullscreen)
end

--设置音量相关
function o:SetVolume()
    --音量
    local volume = self.m_VolumeSlider.value
    g_AudioCtrl:SetVolume(volume)
    volume = tostring(math.floor(volume * 100))
    self.m_VolumeText.text = volume
end
--点击确认
function o:OnClickConfirm()
    --分辨率
    local resolution = Resolutions[self.m_ResolutionDropDown.value + 1]
    ClientData.Set("Resolution",resolution)
    local list = string.split(resolution,"X")
    local width,height = list[1],list[2]

    --全屏
    local fullscreen = self.m_FullScreenToggle.isOn
    fullscreen = fullscreen and "1" or "0"
    ClientData.Set("FullScreen",fullscreen)

    --音量
    local volume = self.m_VolumeSlider.value
    volume = tostring(math.floor(volume * 100))
    ClientData.Set("Volume",volume)

    self.m_SettingGroup:SetActive(false)
end

--[[
    隐藏设置
]]
function o:OnCleanUp()
    
end

function o:Update()
    if CS.UnityEngine.Input.GetKeyDown(CS.UnityEngine.KeyCode.Escape) then
        self:ShowSetting()
    end
    return true
end

function o:ShowSetting()
    self.m_SettingGroup:SetActive(true)
end



return o