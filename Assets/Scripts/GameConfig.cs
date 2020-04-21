using System;
using System.IO;
using UnityEngine;

public class GameConfig
{
    public const string GameName = "ChinaTown";

    public const string Url = "http://www.woodgame.top/";

    public const string Version = "0.0.2";

    public const string AssetBundleOutputPath = "C:/Users/Administrator/Desktop/Server";

    public const string AssetBundleDiffFolder = "Diff";

    public const string AssetTail = ".unity3d";

    //获得带有平台地路径
    public static string GetPlatformPath(string filename)
    {
        string ret = Path.Combine(Platform.GetRuntimePlatform(), filename);
        ret = FileHelper.UnixPath(ret);
        return ret;
    }

    //获得在 streaming中的路径
    public static string GetStreamingPath(string filename,bool platform = true)
    {
        if (platform)
            filename = GetPlatformPath(filename);
        string ret = Path.Combine(Application.streamingAssetsPath ,filename);
        ret = FileHelper.UnixPath(ret);
        return ret;
    }

    //获得在 persitent中的路径
    public static string GetPersitentPath(string filename,bool platform = true)
    {
        if (platform)
            filename = GetPlatformPath(filename);
        string ret = Path.Combine(Application.persistentDataPath, filename);
        ret = FileHelper.UnixPath(ret);
        return ret;
    }

    /// <summary>
    /// 获得读文件路径
    /// </summary>
    /// <param name="filename"></param>
    /// <param name="platform">是否补齐平台</param>
    /// <returns></returns>
    public static string GetWWWReadPath(string filename,bool platform = true)
    {
        string persistentPath = GetPersitentPath(filename,platform);
        string streamingPath = GetStreamingPath(filename,platform);
        string path = "file://";
        if (File.Exists(persistentPath))
            path += persistentPath;
        else
            path += streamingPath;
        return path;
    }

    /// <summary>
    /// 获得读文件路径
    /// </summary>
    /// <param name="filename"></param>
    /// <param name="platform"></param>
    /// <returns></returns>
    public static string GetReadPath(string filename, bool platform = true)
    {
        string persistentPath = GetPersitentPath(filename, platform);
        string streamingPath = GetStreamingPath(filename, platform);
        if (File.Exists(persistentPath))
            return persistentPath;
        else
            return streamingPath;
    }

    /// <summary>
    /// 获得资源url
    /// </summary>
    /// <param name="res"></param>
    /// <returns></returns>
    public static string GetResUrl(string res)
    {
        string ret = Url + GetPlatformPath(res);
        return ret;
    }

    /// <summary>
    /// 获得输出路径
    /// </summary>
    /// <returns></returns>
    public static string GetAssetBundleOutputPath()
    {
        string ret = Path.Combine(AssetBundleOutputPath, Platform.GetRuntimePlatform());
        ret = FileHelper.UnixPath(ret);
        return ret;
    }

    /// <summary>
    /// 获得差异路径
    /// </summary>
    /// <returns></returns>
    public static string GetAssetBundleDiffPath()
    {
        string ret = Path.Combine(AssetBundleOutputPath,AssetBundleDiffFolder, Platform.GetRuntimePlatform());
        ret = FileHelper.UnixPath(ret);
        return ret;
    }


}