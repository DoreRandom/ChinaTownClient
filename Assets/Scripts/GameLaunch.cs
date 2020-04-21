using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using UnityEngine;
using XLua;
using UnityEngine.UI;
using UnityEngine.EventSystems;
using DG.Tweening;

namespace Game
{
    public class GameLaunch : MonoBehaviour
    {

        LuaEnv env = null;
        LuaFunction luaStart =null;
        LuaFunction luaUpdate = null;
        LuaFunction luaLateUpdate = null;
        LuaFunction luaPause =null;
        LuaFunction luaOnApplicationQuit = null;

        private DateTime pauseTime;
        private TimeSpan leftTime;

        
        void Awake()
        {
            env = new LuaEnv();

            env.AddLoader(CustomMyLoader);

            env.DoString(@"
            GMAIN = require 'main'
        ");
            LuaTable luaTable = env.Global.Get<LuaTable>("GMAIN");
            luaStart = luaTable.Get<LuaFunction>("start");
            luaUpdate = luaTable.Get<LuaFunction>("update");
            luaLateUpdate = luaTable.Get<LuaFunction>("lateupdate");
            luaPause = luaTable.Get<LuaFunction>("pause");
            luaOnApplicationQuit = luaTable.Get<LuaFunction>("onApplicationQuit");
        }


        private byte[] CustomMyLoader(ref string fileName)
        {

            fileName = fileName.Replace(".","/");
            string luaPath = "";
#if UNITY_EDITOR
            luaPath = Application.dataPath + "/Lua/" + fileName + ".lua";
            string strLuaContent = File.ReadAllText(luaPath);
            byte[] result = System.Text.Encoding.UTF8.GetBytes(strLuaContent);
            return result;
#else

            luaPath = fileName + ".lua";
            return System.Text.Encoding.UTF8.GetBytes(LuaManager.instance.GetLua(luaPath));
#endif

        }

        void Start()
        {
            if (luaStart != null)
            {
                luaStart.Call();
            }

        }

        void Update()
        {
            if (luaUpdate != null)
            {
                luaUpdate.Call(Time.deltaTime);
            }
        }

        void LateUpdate()
        {
            if (luaLateUpdate != null)
            {
                luaLateUpdate.Call(Time.deltaTime);
            }
           
        }

        private void OnApplicationPause(bool paused)
        {
            if (!paused)
            {
                leftTime = DateTime.UtcNow - pauseTime;
                luaPause.Call(paused,leftTime.TotalSeconds);
            }
            else
            {
                pauseTime = DateTime.UtcNow;
            }
        }

        private void OnApplicationQuit()
        {
            if (luaOnApplicationQuit != null)
            {
                luaOnApplicationQuit.Call();
            }
        }
    }
}
