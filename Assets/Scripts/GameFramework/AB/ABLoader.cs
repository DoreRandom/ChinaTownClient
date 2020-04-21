using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Threading.Tasks;
using UnityEngine;

public class ABLoader : MonoSingleton<ABLoader>
{
    public class ABRequest
    {
        public string name;
        public Type type;
        public Action<object> callback;
        public Action<string> errorback;
    }

    List<ABRequest> m_LoadList = new List<ABRequest>(); //加载列表
    /// 加载目标资源
    public void LoadAssetBundle(string name,Type type, Action<object> callback,Action<string> errorback = null)
    {

        Action<object> c = (obj) =>{
            callback(obj);

            m_LoadList.RemoveAt(0);
            if (m_LoadList.Count > 0)
                InnerLoadAssetBundle();
        };
        //出现问题立即停止加载
        Action<string> e = (msg) =>
        {
            ABLoader.Instance.StopAllCoroutines();
            m_LoadList.Clear();
            if (errorback != null)
                errorback(msg);
        };

        m_LoadList.Add(new ABRequest() { name = name.ToLower(),type=type,callback = c, errorback = e});

        if (m_LoadList.Count == 1)
        {
            
            //启动
            InnerLoadAssetBundle();
        }
    }

    //真正地加载资源
    private void InnerLoadAssetBundle()
    {
        ABRequest abRequest = m_LoadList[0];

        string name = abRequest.name;
        Type type = abRequest.type;
        Action< object > callback = abRequest.callback;
        Action<string> errorback = abRequest.errorback;
        name = name + GameConfig.AssetTail; //eg:ui/panel.unity3d
        Action<List<AssetBundle>> action = (depenceAssetBundles) => {
            string realName = GameConfig.GetPlatformPath(name); //eg:Windows/ui/panel.unity3d
            string path = GameConfig.GetWWWReadPath(realName, false);
            LoadRes(path, (www) => {
                if (www.error != null)
                {
                    errorback(www.error);
                    return;
                }

                int index = realName.LastIndexOf("/");
                string assetName = realName.Substring(index + 1);
                assetName = assetName.Replace(GameConfig.AssetTail, "");
                AssetBundle assetBundle = www.assetBundle;
                UnityEngine.Object obj = assetBundle.LoadAsset(assetName,type); //LoadAsset(name),这个name没有后缀,eg:panel
                //卸载资源内存
                assetBundle.Unload(false);
                foreach (AssetBundle depenceAssetBundle in depenceAssetBundles)
                {
                    depenceAssetBundle.Unload(false);
                }
                //加载目标资源完成的回调
                callback(obj);
            });
        };
        LoadDependenceAssets(name, action, errorback);
    }


    /// 加载目标资源的依赖资源
    private void LoadDependenceAssets(string targetAssetName, Action<List<AssetBundle>> action,Action<string> errorback)
    {
        //Debug.Log("要加载的目标资源:" + targetAssetName); //ui/panel.unity3d
        Action<AssetBundleManifest> dependenceAction = (manifest) => {
            List<AssetBundle> depenceAssetBundles = new List<AssetBundle>(); //用来存放加载出来的依赖资源的AssetBundle
            string[] dependences = manifest.GetAllDependencies(targetAssetName);
            //Debug.Log("依赖文件个数：" + dependences.Length);
            int length = dependences.Length;
            int finishedCount = 0;
            if (length == 0)
            {
                //没有依赖
                action(depenceAssetBundles);
            }
            else
            {
                //有依赖，加载所有依赖资源
                for (int i = 0; i < length; i++)
                {
                    string dependenceAssetName = dependences[i];
                    dependenceAssetName = GameConfig.GetPlatformPath(dependenceAssetName); //eg:Windows/altas/heroiconatlas.unity3d
                    string path = GameConfig.GetWWWReadPath(dependenceAssetName, false);
                    LoadRes(path, (www) => {
                        if (www.error != null)
                        {
                            errorback(www.error);
                            return;
                        }
                        int index = dependenceAssetName.LastIndexOf("/");
                        string assetName = dependenceAssetName.Substring(index + 1);
                        assetName = assetName.Replace(GameConfig.AssetTail, "");
                        AssetBundle assetBundle = www.assetBundle;
                        assetBundle.LoadAsset(assetName);
                        depenceAssetBundles.Add(assetBundle);
                        finishedCount++;
                        if (finishedCount == length)
                        {
                            //依赖都加载完了
                            action(depenceAssetBundles);
                        }
                    });
                }
            }
        };
        LoadAssetBundleManifest(dependenceAction,errorback);
    }

    /// 加载AssetBundleManifest
    private void LoadAssetBundleManifest(Action<AssetBundleManifest> action, Action<string> errorback)
    {
        string manifestName = GameConfig.GetPlatformPath(Platform.GetRuntimePlatform());
        string path = GameConfig.GetWWWReadPath(manifestName, false);
        LoadRes(path, (www) => {
            if (www.error != null)
            {
                errorback(www.error);
                return;
            }

            AssetBundle assetBundle = www.assetBundle;
            UnityEngine.Object obj = assetBundle.LoadAsset("AssetBundleManifest");
            assetBundle.Unload(false);
            AssetBundleManifest manif = obj as AssetBundleManifest;
            action(manif);
        });
    }

    //加载资源
    public void LoadRes(string path, Action<WWW> callback)
    {
        StartCoroutine(CoLoadRes(path, callback));
    }

    IEnumerator CoLoadRes(string path, Action<WWW> callback)
    {
        WWW www = new WWW(path);
        yield
        return www;
        if (www.isDone)
        {
            callback(www);
        }
    }


}
