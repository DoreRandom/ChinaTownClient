local UIUtil = {}

function UIUtil.GetChild(trans, index)
	return trans:GetChild(index)
end

-- 注意：根节点不能是隐藏状态，否则路径将找不到
function UIUtil.FindComponent(trans, ctype, path)
	assert(trans ~= nil)
	assert(ctype ~= nil)
	
	local targetTrans = trans
	if path ~= nil and type(path) == "string" and #path > 0 then
		targetTrans = trans:Find(path)
	end
	if targetTrans == nil then
		return nil
	end
	local cmp = targetTrans:GetComponent(ctype)
	if cmp ~= nil then
		return cmp
	end
	return targetTrans:GetComponentInChildren(ctype)
end

function UIUtil.FindTrans(trans, path)
	return trans:Find(path)
end

function UIUtil.FindText(trans, path)
	return FindComponent(trans, typeof(CS.UnityEngine.UI.Text), path)
end

function UIUtil.FindImage(trans, path)
	return FindComponent(trans, typeof(CS.UnityEngine.UI.Image), path)
end

function UIUtil.FindButton(trans, path)
	return FindComponent(trans, typeof(CS.UnityEngine.UI.Button), path)
end

function UIUtil.FindInput(trans, path)
	return FindComponent(trans, typeof(CS.UnityEngine.UI.InputField), path)
end

function UIUtil.FindSlider(trans, path)
	return FindComponent(trans, typeof(CS.UnityEngine.UI.Slider), path)
end

function UIUtil.FindScrollRect(trans, path)
	return FindComponent(trans, typeof(CS.UnityEngine.UI.ScrollRect), path)
end

return UIUtil