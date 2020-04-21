local o = class("CAudioCtrl",CCtrlBase)

function o:ctor()
    CCtrlBase.ctor(self)

    local bgmGo = CS.UnityEngine.GameObject("bgm")
    self.m_BgmAudio =  bgmGo:AddComponent(typeof(CS.UnityEngine.AudioSource))
    self.m_BgmAudio.loop = true
    CS.UnityEngine.Object.DontDestroyOnLoad(bgmGo)
    
end

--播放特效音
function o:Play(path,volume)
    volume = volume  or 1
    g_ResCtrl:LoadAsset(path,typeof(CS.UnityEngine.AudioClip),function (clip)
        local go = CS.UnityEngine.GameObject("audio")
        go.transform.localPosition = Vector3.New(0,0,0)
        go.hideFlags = CS.UnityEngine.HideFlags.HideInHierarchy
        
        local source = go:AddComponent(typeof(CS.UnityEngine.AudioSource))
        source.clip = clip
        source.volume = volume
        source:Play()
        CS.UnityEngine.GameObject.Destroy(go,clip.length)
    end)
end

--播放背景音
function o:PlayBgm(path,volume)
    volume = volume  or 1
    g_ResCtrl:LoadAsset(path,typeof(CS.UnityEngine.AudioClip),function (clip)
        self.m_BgmAudio.clip = clip
        self.m_BgmAudio.volume = volume
        self.m_BgmAudio:Play()
    end)
end

--设置音量大小
function o:SetVolume(volume)
    CS.UnityEngine.AudioListener.volume = volume
end

return o