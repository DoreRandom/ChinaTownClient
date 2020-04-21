using System;
using System.Collections.Generic;
using UnityEngine;


namespace Game
{
    public class LuaManager : Singleton<LuaManager>
    {
        Dictionary<string, string> m_LuaDict = new Dictionary<string, string>();
        public LuaManager()
        {
        }

        /// <summary>
        /// 初始化
        /// </summary>
        /// <param name="fileListJson"></param>
        /// <param name="callback"></param>
        public void Init(FileListJson fileListJson,Action callback,Action<string> errorback)
        {
            int count = 0;
            foreach (FileJson json in fileListJson.FileList)
            {
                string filename = json.FileName;
                if (filename.EndsWith(".lua" + GameConfig.AssetTail))
                {
                    filename = filename.Replace(GameConfig.AssetTail, "");
                    string prefix = GameConfig.GameName + "/Lua/";
                    int index = prefix.Length;
                    string luaName = filename.Substring(index);

                    count++;
                    ABLoader.Instance.LoadAssetBundle(filename,typeof(TextAsset), (obj) =>
                    {
                        TextAsset text = obj as TextAsset;
                        m_LuaDict[luaName] = text.text;
                        count--;
                        if (count == 0)
                        {
                            callback();
                        }
                        
                    },errorback);
                }
            }
        }

        //获得lua文件
        public string GetLua(string luaName)
        {
            luaName = luaName.ToLower();
            return m_LuaDict[luaName];
        }

        public override void Dispose()
        {
            
        }
    }

}