using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using System.Collections.Generic;
using System;
using System.IO;
using UnityEngine.SceneManagement;

namespace Game
{
    //数据

    public class VersionJson
    {
        public string Version;

        //获得版本
        public int GetVersionNum()
        {
            string[] vlist = Version.Split(new char[] { '.' });
            if (vlist.Length != 3)
            {
                return 0;
            }
            int ret = int.Parse(vlist[0]);
            ret *= 100;
            ret += int.Parse(vlist[1]);
            ret *= 100;
            ret += int.Parse(vlist[2]);
            return ret;
        }
    }

    [Serializable]
    public class FileJson
    {
        public string MD5;
        public string FileName;
    }

    [Serializable]
    public class FileListJson
    {
        [SerializeField]
        public List<FileJson> FileList = new List<FileJson>();
    }


    public class GameLoader : MonoBehaviour
    {

        public Canvas InitCanvas; //负责显示初始化页面的canvas
        InitView m_InitView; //初始化页面地抽象
        NotifyView m_NotifyView;//通知页面
        VersionJson m_LocalVersion; //本地版本
        VersionJson m_ServerVersion; //网路版本
        FileListJson m_LocalFileList; //本地文件列表
        FileListJson m_ServerFileList; //网络文件列表

        float m_Progress = 0f; //进度


        void Start()
        {

            Setting();
#if UNITY_EDITOR
            StartGame();
            return;
#else

            OpenInitView();
#endif
        }

        //设置屏幕和音量
        void Setting()
        {
            //屏幕
            string resolution = PlayerPrefs.GetString("Resolution","1280X720");
            string[] list = resolution.Split(new char[] { 'X' });
            int width = int.Parse(list[0]);
            int height = int.Parse(list[1]);

            string fullscreen = PlayerPrefs.GetString("FullScreen", "0");
            bool isFullScreen = fullscreen != "0";

            Screen.SetResolution(width,height, isFullScreen);

            string volume = PlayerPrefs.GetString("Volume","100");
            float nVolume = float.Parse(volume) / 100;
            AudioListener.volume = nVolume;
        }

        #region 打开起始页面
        public void OpenInitView()
        {
            string path = "ChinaTown/UI/Common/InitView";

            Action<object> callback = (obj) =>
            {
                GameObject go = GameObject.Instantiate(obj as GameObject) as GameObject;
                go.transform.SetParent(InitCanvas.transform);
                go.transform.localScale = Vector3.one;
                go.transform.localPosition = Vector3.zero;

                m_InitView = new InitView(go);

                OpenNotifyView();
            };

            Action<string> errorback = (msg) => 
            {
                object obj = Resources.Load<GameObject>(path);
                callback(obj);
            };

            ABLoader.Instance.LoadAssetBundle(path,typeof(GameObject), callback,errorback);
            
        }

        public void OpenNotifyView()
        {
            string path = "ChinaTown/UI/Common/NotifyView";

            Action<object> callback = (obj) =>
            {
                GameObject go = GameObject.Instantiate(obj as GameObject) as GameObject;
                go.transform.SetParent(InitCanvas.transform);
                go.transform.localScale = Vector3.one;
                go.transform.localPosition = Vector3.zero;

                m_NotifyView = new NotifyView(go);
                GetLocalVersion();
            };

            Action<string> errorback = (msg) =>
            {
                object obj = Resources.Load<GameObject>(path);
                callback(obj);
            };

            ABLoader.Instance.LoadAssetBundle(path,typeof(GameObject),callback,errorback);
        }

#endregion

#region 检查版本
        //获得本地版本
        public void GetLocalVersion()
        {
            m_InitView.SetTitle("获得本地版本");

            string path = GameConfig.GetWWWReadPath("chinatown/version.txt");

            ABLoader.Instance.LoadRes(path, (www) =>
            {
                if (www.error != null)
                {
                    InitFailed("获得本地版本失败");
                    return;
                }

                m_LocalVersion = JsonUtility.FromJson<VersionJson>(www.text);

                m_InitView.SetVersion(m_LocalVersion.Version);

                GetServerVersion();
            });
        }

        //获得服务器版本
        public void GetServerVersion()
        {
            m_InitView.SetTitle("获得服务器版本");

            string url = GameConfig.GetResUrl("chinatown/version.txt");
            ABLoader.Instance.LoadRes(url, (www) =>
            {
                if (www.error != null)
                {
                    InitFailed("获得服务器版本失败");
                    return;
                }

                m_ServerVersion = JsonUtility.FromJson<VersionJson>(www.text);

                CheckVersion();
            });

        }
        //检查服务器版本
        public void CheckVersion()
        {
            m_Progress += 0.1f;
            m_InitView.SetProgress(m_Progress);
            if (m_ServerVersion.GetVersionNum() > m_LocalVersion.GetVersionNum())
            {
                GetLocalFileList();
            }
            else
            {
                //进入游戏
                CheckFile();
            }
        }

#endregion

#region 更新文件
        //获得本地文件
        public void GetLocalFileList()
        {
            m_InitView.SetTitle("获得本地文件列表");

            string path = GameConfig.GetWWWReadPath("chinatown/filelist.txt");

            ABLoader.Instance.LoadRes(path, (www) =>
            {
                if (www.error != null)
                {
                    InitFailed("获得本地文件列表失败");
                    return;
                }

                string text = www.text;
                m_LocalFileList = JsonUtility.FromJson<FileListJson>(text);

                GetServerFileList();

            });
        }

        //获得服务器版本列表
        public void GetServerFileList()
        {
            m_InitView.SetTitle("获得服务器文件列表");
            string url = GameConfig.GetResUrl("chinatown/filelist.txt");
            ABLoader.Instance.LoadRes(url, (www) =>
            {
                if (www.error != null)
                {
                    InitFailed("获得服务器文件列表失败");
                    return;
                }

                string text = www.text;
                m_ServerFileList = JsonUtility.FromJson<FileListJson>(text);

                CompareFileList();
            });
        }

        //比对文件列表
        public void CompareFileList()
        {
            m_Progress += 0.1f;
            m_InitView.SetProgress(m_Progress);

            Dictionary<string, FileJson> dic = new Dictionary<string, FileJson>();

            foreach (FileJson fileJson in m_ServerFileList.FileList)
            {
                string key = fileJson.FileName + fileJson.MD5;
                dic[key] = fileJson;
            }

            foreach (FileJson fileJson in m_LocalFileList.FileList)
            {
                string key = fileJson.FileName + fileJson.MD5;
                if (dic.ContainsKey(key))
                {
                    dic.Remove(key);
                }
            }

            Debug.Log(dic.Count); //TODO 获取更新文件大小

            DownLoadNewFile(dic);
        }

        //下载文件列表
        public void DownLoadNewFile(Dictionary<string, FileJson> dic)
        {
            m_InitView.SetTitle("开始下载");
            int count = dic.Count;
            int num = 0;

            float p = 1 - m_Progress;

            foreach (FileJson fileJson in dic.Values)
            {
                HttpHelper.Instance.DownLoadFile(fileJson.FileName, (success) =>
                {
                    if (!success)
                    {
                        InitFailed("下载资源失败");
                        return;
                    }
                    num += 1;
                    m_InitView.SetDetail(String.Format("下载 {0} 完成", fileJson.FileName));

                    m_InitView.SetProgress(m_Progress += (p / (float)count));

                    if (count == num)
                    {
                        Debug.Log("下载完成");
                        UpdateFile();
                    }
                });
            }
        }

        //更新文件
        public void UpdateFile()
        {
            //更新md5
            string fp = GameConfig.GetPersitentPath("chinatown/filelist.txt");
            string fd = FileHelper.GetDir(fp);
            if (!Directory.Exists(fd))
                Directory.CreateDirectory(fd);
            File.WriteAllText(fp, JsonUtility.ToJson(m_ServerFileList));
            //更新version
            string vp = GameConfig.GetPersitentPath("chinatown/version.txt");
            string vd = FileHelper.GetDir(vp);
            if (!Directory.Exists(vd))
                Directory.CreateDirectory(vd);
            File.WriteAllText(vp, JsonUtility.ToJson(m_ServerVersion));


            //更新版本显示
            m_InitView.SetVersion(m_ServerVersion.Version);
            CheckFile();
        }
#endregion

#region 校验文件
        //校验文件
        void CheckFile()
        {
            m_InitView.SetTitle("校验文件");
            string path = GameConfig.GetWWWReadPath("chinatown/filelist.txt");

            ABLoader.Instance.LoadRes(path, (www) =>
            {
                if (www.error != null)
                {
                    InitFailed("获取校验列表失败");
                    return;
                }

                string text = www.text;
                FileListJson json = JsonUtility.FromJson<FileListJson>(text);

               StartCheckFile(json);
            });
        }

        //开始校验文件
        void StartCheckFile(FileListJson fileListJson)
        {
            var fileList = fileListJson.FileList;

            foreach (FileJson fileJson in fileList)
            {
                string filename = fileJson.FileName;
                string md5 = fileJson.MD5;
                string path = GameConfig.GetReadPath(filename);
                string checkMD5 = FileHelper.GetMD5HashFromFile(path);

                if (md5 != checkMD5)
                {
                    string fp = GameConfig.GetPersitentPath("chinatown/filelist.txt");
                    string vp = GameConfig.GetPersitentPath("chinatown/version.txt");
                    //将之前的更新文件删除
                    File.Delete(fp);
                    File.Delete(vp);
                    InitFailed("校验文件失败");
                    return;
                }
            }

            InitLua(fileListJson);
        }
#endregion

#region lua文件缓存
        //初始化lua
        void InitLua(FileListJson fileListJson)
        {
            m_InitView.SetDetail("");
            m_InitView.SetTitle("加载脚本");
            LuaManager.instance.Init(fileListJson,
            () =>
            {
                StartGame();
            },
            (msg) =>
            {
                InitFailed("脚本加载失败");
            }
            );
        }
#endregion


        //初始化失败
        void InitFailed(string reason)
        {
            m_NotifyView.Notify(
                "错误",
                reason,
                () => {
                    SceneManager.LoadScene(0);
                },
                "重试",
                () => {
                    Application.Quit();
                },
                "退出"
                );

        }

        //开始游戏
        void StartGame()
        {
            if (m_NotifyView != null)
                m_NotifyView.Destroy();

            if(m_InitView != null)
                m_InitView.Destroy();


            this.gameObject.AddComponent<GameLaunch>();

            
        }




    }

}