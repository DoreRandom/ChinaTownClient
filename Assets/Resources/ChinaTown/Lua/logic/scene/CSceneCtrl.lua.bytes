local o = class("CSceneCtrl",CDelayCallBase)

function o.ctor(self)
    CDelayCallBase.ctor(self)
    
    self.m_CurrentScene = nil --当前场景
    self.m_Busing = nil --是否忙
end
--加载场景之前需要的操作
function o:BeforeLoad()
    g_NetCtrl:SetSubspend(true)  --暂停处理消息
end

function o:AfterLoad()
    g_NetCtrl:SetSubspend(false) -- 取消暂停
end

function o:InnerSwitchScene(cscene)
    self.m_TodoList = {}
    self.m_Busing = true
    local value = 0
    local resAsync = nil
    --TODO 这里可能需要一般的scene加载
    --加载之前需要做的操作
    self:BeforeLoad()
    table.insert(self.m_TodoList,function ()
        --打开loading页面
        CLoadingView:ShowView()
        return true
    end)
    table.insert(self.m_TodoList,function ()
        --查看是否打开
        local view = CLoadingView:GetView()
        return view ~= nil
    end)
    table.insert(self.m_TodoList,function ()
        --旧场景清理
        local view = CLoadingView:GetView()
        if self.m_CurrentScene then
            self.m_CurrentScene:OnLeave()
        end
        value = value + 0.01
        view:SetProgress(value)
        return true
    end)
    table.insert(self.m_TodoList,function ()
        --清理UI
        local view = CLoadingView:GetView()
        g_ViewCtrl:CleanUp()
        value = value + 0.01
        view:SetProgress(value)
        return true
    end)
    table.insert(self.m_TodoList,function ()
        --清理res
        local view = CLoadingView:GetView()
        g_ResCtrl:CleanUp()
        value = value + 0.01
        view:SetProgress(value)
        return true
    end)
    table.insert(self.m_TodoList,function ()
        --GC
        local view = CLoadingView:GetView()
        collectgarbage("collect")
        CS.System.GC.Collect()
        collectgarbage("collect")
        CS.System.GC.Collect()
        value = value + 0.01
        view:SetProgress(value)
        return true
    end)
    table.insert(self.m_TodoList,function ()
        --卸载不用的资源
        if resAsync == nil then
            resAsync = CS.UnityEngine.Resources.UnloadUnusedAssets();
        end
        local view = CLoadingView:GetView()
        local curProgress = value + 0.1 * resAsync.progress
        view:SetProgress(curProgress)
        if resAsync.completed then
            value = curProgress
            return true
        end
    end)
    table.insert(self.m_TodoList,function ()
        --进出场景之前的准备
        self.m_CurrentScene = cscene.New()
        self.m_CurrentScene:OnEnter()
        self.m_CurrentScene:PreloadProgress()
        return true
    end)
    table.insert(self.m_TodoList,function ()
        --等待场景加载完毕
        if(self.m_CurrentScene:LoadDone()) then
            local view = CLoadingView:GetView()
            view:SetProgress(1)
            return true
        end
    end)
    table.insert(self.m_TodoList,function ()
        --完成加载
        self.m_CurrentScene:OnComplete()
        CLoadingView:CloseView()
        self.m_Busing = false
        self:AfterLoad()
        return true
    end)
    self:DelayCall(0,"DoProgress")

end

function o:DoProgress()
    local f = self.m_TodoList[1]
    local ok = f()
    if ok then
        table.remove(self.m_TodoList,1)
        if #self.m_TodoList == 0 then
            return nil
        end

        return true
    else
        return true
    end
end

function o:SwitchScene(cscene)
    if self.m_Busing then
        return
    end
    if self.m_CurrentScene and self.m_CurrentScene.classname == cscene.classname then
        return   
    end
    self:InnerSwitchScene(cscene)
end



return o