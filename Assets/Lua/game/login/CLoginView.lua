local o = class("CLoginView",CViewBase)

o.Config = {
    PrefabPath = "ChinaTown/UI/Login/LoginView",
    Layer = UILayers.NormalLayer,
    Recycle = true
}

function o.ctor(self,cb)
    CViewBase.ctor(self, cb)
    self.m_PrefabPath = o.Config.PrefabPath
    self.m_Layer = o.Config.Layer
    self.m_Recycle = o.Config.Recycle
end

function o.OnCreateView(self)
    self.m_AccountInput = self:GetUI(1,UIInputField)
    self.m_PwdInput = self:GetUI(2,UIInputField)
    self.m_LoginBtn = self:GetUI(3,UIButton)
    self.m_RegBtn = self:GetUI(4,UIButton)
    self.m_QuitBtn = self:GetUI(5,UIButton)

    self.m_LoginBtn.onClick:AddListener(function ()
        self:LoginServer(false)
    end)

    self.m_RegBtn.onClick:AddListener(function ()
        self:LoginServer(true)
    end)

    self.m_QuitBtn.onClick:AddListener(function ()
        self:OnClickQuit()
    end)
end

function o:OnShowView()
    local info = g_LoginCtrl:GetLoginInfo()
    if not info then
        return
    end
    self.m_AccountInput.text = info.account
    self.m_PwdInput.text = info.pwd
end

--设置登陆信息
function o:LoginServer(isReg)
    local account = self.m_AccountInput.text
    local pwd = self.m_PwdInput.text
    if string.len(account) < 6 then
        CNotifyView.Notify("错误","账号不应短于6")
        return 
    end
    if string.len(account) > 15 then
        CNotifyView.Notify("错误","账号不应长于15")
        return
    end
    if string.len(pwd) < 6 then
        CNotifyView.Notify("错误","密码不应短于6")
        return 
    end
    if string.len(pwd) > 15 then
        CNotifyView.Notify("错误","账号不应长于15")
        return 
    end

    g_LoginCtrl:LoginServer(account,pwd,isReg)
end

function o:OnClickQuit()
    CS.UnityEngine.Application.Quit()
end

return o