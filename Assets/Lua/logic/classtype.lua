local classtype = {}

UnityEngine = CS.UnityEngine

classtype.GameObject = typeof(CS.UnityEngine.GameObject)
classtype.Camera = typeof(CS.UnityEngine.Camera)
classtype.Sprite = typeof(CS.UnityEngine.Sprite)
classtype.AudioSource = typeof(CS.UnityEngine.AudioSource)
classtype.AudioClip = typeof(CS.UnityEngine.AudioClip)
classtype.TextAsset = typeof(CS.UnityEngine.TextAsset)

--UGUI
classtype.Canvas = typeof(CS.UnityEngine.Canvas)
classtype.CanvasScaler = typeof(CS.UnityEngine.UI.CanvasScaler)
classtype.GraphicRaycaster = typeof(CS.UnityEngine.UI.GraphicRaycaster)
classtype.RectTransform = typeof(CS.UnityEngine.RectTransform)

UIRectTransform = typeof(CS.UnityEngine.RectTransform)
UIButton = typeof(CS.UnityEngine.UI.Button)
UIInputField = typeof(CS.UnityEngine.UI.InputField)
UIText = typeof(CS.UnityEngine.UI.Text)
UIImage = typeof(CS.UnityEngine.UI.Image)
UIDropdown = typeof(CS.UnityEngine.UI.Dropdown)
UIToggle = typeof(CS.UnityEngine.UI.Toggle)
UISlider = typeof(CS.UnityEngine.UI.Slider)

return classtype