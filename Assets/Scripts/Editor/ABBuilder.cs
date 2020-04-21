using UnityEngine;
using System.Collections;
using UnityEditor;
using System.IO;
using System;
using System.Collections.Generic;
using Game;


public class ABBuilder : Editor
{
    private static string EditorLuaPath = "Lua"; //editor下的lua路径
    private static string ResLuaPath = "Resources/" + GameConfig.GameName + "/Lua"; //lua要保存地路径

    private static string ABResPath = "Resources/" + GameConfig.GameName;//需要打包的根目录


    //删除文件夹
    public static void DelectDir(string srcPath)
    {
        try
        {
            DirectoryInfo dir = new DirectoryInfo(srcPath);
            FileSystemInfo[] fileinfo = dir.GetFileSystemInfos();  //返回目录中所有文件和子目录
            foreach (FileSystemInfo i in fileinfo)
            {
                if (i is DirectoryInfo)            //判断是否文件夹
                {
                    DirectoryInfo subdir = new DirectoryInfo(i.FullName);
                    subdir.Delete(true);          //删除子目录和文件
                }
                else
                {
                    File.Delete(i.FullName);      //删除指定文件
                }
            }
        }
        catch (Exception e)
        {
            Debug.Log(e.Message);
            throw;
        }
    }

    #region lua移动到资源文件内
    [MenuItem("Tools/AB/lua文件打包")]
    public static void MoveLuaToResources()
    {
        var sourcePath = FileHelper.UnixPath(Path.Combine(Application.dataPath, EditorLuaPath));
        var destPath = FileHelper.UnixPath(Path.Combine(Application.dataPath, ResLuaPath));

        if (Directory.Exists(destPath))
        {
            DelectDir(destPath);
        }
        
        CopyLua(sourcePath,destPath,true);
        Debug.Log("lua文件打包");
    }

    //赋值lua 并保存为bytes
    private static bool CopyLua(string sourcePath, string destinationPath, bool overwriteexisting = true)
    {
        bool ret = false;
        try
        {
            sourcePath = sourcePath.EndsWith("/") ? sourcePath : sourcePath + "/";
            destinationPath = destinationPath.EndsWith("/") ? destinationPath : destinationPath + "/";

            if (Directory.Exists(sourcePath))
            {
                if (Directory.Exists(destinationPath) == false)
                    Directory.CreateDirectory(destinationPath);

                foreach (string fls in Directory.GetFiles(sourcePath))
                {
                    if (fls.EndsWith(".meta"))
                    {
                        continue;
                    }

                    FileInfo flinfo = new FileInfo(fls);
                    flinfo.CopyTo(destinationPath + flinfo.Name + ".bytes", overwriteexisting);
                }
                foreach (string drs in Directory.GetDirectories(sourcePath))
                {
                    DirectoryInfo drinfo = new DirectoryInfo(drs);
                    if (CopyLua(drs, destinationPath + drinfo.Name, overwriteexisting) == false)
                        ret = false;
                }
            }
            ret = true;
        }
        catch (Exception e)
        {
            Debug.Log(e.Message);
            ret = false;
        }

        AssetDatabase.Refresh();

        return ret;
    }

    #endregion


    #region ab打包
    [MenuItem("Tools/AB/清空ABName")]
    static void ClearAssetBundlesName()
    {
        int length = AssetDatabase.GetAllAssetBundleNames().Length;
        string[] oldAssetBundleNames = new string[length];
        for (int i = 0; i < length; i++)
        {
            oldAssetBundleNames[i] = AssetDatabase.GetAllAssetBundleNames()[i];
        }

        for (int j = 0; j < oldAssetBundleNames.Length; j++)
        {
            AssetDatabase.RemoveAssetBundleName(oldAssetBundleNames[j], true);
        }

        AssetDatabase.Refresh();
        Debug.Log("清空ABName");
    }

    [MenuItem("Tools/AB/生成ABName")]
    static void MakeAssetBundleName()
    {
        string path = FileHelper.UnixPath(Path.Combine(Application.dataPath, ABResPath));
        SetAssetBundleName(path);

        AssetDatabase.Refresh();
        Debug.Log("生成ABName");
    }
    
    //设置assetbundle名字
    static void SetAssetBundleName(string source)
    {
        DirectoryInfo folder = new DirectoryInfo(source);
        FileSystemInfo[] files = folder.GetFileSystemInfos();
        int length = files.Length;
        for (int i = 0; i < length; i++)
        {
            if (files[i] is DirectoryInfo)
            {
                SetAssetBundleName(files[i].FullName);
            }
            else
            {
                if (!files[i].Name.EndsWith(".meta"))
                {
                    FileSetAssetBundleName(files[i].FullName);

                }
            }
        }
    }
    //具体设置abname
    static void FileSetAssetBundleName(string path)
    {
        string source = FileHelper.UnixPath(path);
        string assetPath = "Assets" + source.Substring(Application.dataPath.Length);
        string assetSubPath = source.Substring(Application.dataPath.Length + 1); //截取之后地

        //在代码中给资源设置AssetBundleName  
        AssetImporter assetImporter = AssetImporter.GetAtPath(assetPath);
        string assetName = assetSubPath.Substring(assetSubPath.IndexOf("/") + 1);
        assetName = assetName.Replace(Path.GetExtension(assetName),GameConfig.AssetTail);
        assetImporter.assetBundleName = assetName;
    }

    //创建ab包
    [MenuItem("Tools/AB/打包AB包")]
    static void BuildAssetBundle()
    {
        string outPath = GameConfig.GetAssetBundleOutputPath();

        if (Directory.Exists(outPath))
        {
            DelectDir(outPath);
        }

        Directory.CreateDirectory(outPath);

        BuildPipeline.BuildAssetBundles(outPath, 0, EditorUserBuildSettings.activeBuildTarget);

        AssetDatabase.Refresh();

        Debug.Log("打包AB包");
    }

    //平台文件夹
    public static string GetPlatformFolder(BuildTarget target)
    {
        switch (target)
        {
            case BuildTarget.Android:
                return "Android";
            case BuildTarget.iOS:
                return "IOS";
            case BuildTarget.StandaloneWindows:
            case BuildTarget.StandaloneWindows64:
                return "Windows";
            default:
                return null;
        }
    }

    #endregion


    #region 文件列表
    static void GenFileList()
    {

        string outPath = GameConfig.GetAssetBundleOutputPath();
        string fileListPath = outPath + "/" + GameConfig.GameName.ToLower() + "/filelist.txt";
        if (!Directory.Exists(outPath))
        {
            Debug.Log("不存在该文件");
            return;
        }

        List<FileJson> fileList = new List<FileJson>();
        AddFileMD5(outPath, fileList);

        if (File.Exists(fileListPath))
        {
            File.Delete(fileListPath);
        }

        FileListJson fileListJson = new FileListJson();
        fileListJson.FileList = fileList;
        string content = JsonUtility.ToJson(fileListJson,true);
        File.WriteAllText(fileListPath,content);

        AssetDatabase.Refresh();
        Debug.Log("生成文件列表");
    }

    //添加文件地md5
    static void AddFileMD5(string source,List<FileJson> list)
    {
        DirectoryInfo folder = new DirectoryInfo(source);
        FileSystemInfo[] files = folder.GetFileSystemInfos();
        int length = files.Length;
        for (int i = 0; i < length; i++)
        {
            if (files[i] is DirectoryInfo)
            {
                AddFileMD5(files[i].FullName,list);
            }
            else
            {
                string fullName = FileHelper.UnixPath(files[i].FullName);
                if (fullName.EndsWith(GameConfig.AssetTail))
                {
                    string md5 = FileHelper.GetMD5HashFromFile(fullName);
                    int index = fullName.LastIndexOf(GameConfig.GameName.ToLower() + "/");

                    FileJson fileJson = new FileJson();
                    fileJson.MD5 = md5;
                    fileJson.FileName = fullName.Substring(index);
                    list.Add(fileJson);
                }
            }
        }
    }


    #endregion

    #region 产生版本文件
    static void GenVersion()
    {
        VersionJson version = new VersionJson() { Version = GameConfig.Version};

        string outPath  = GameConfig.GetAssetBundleOutputPath();
        string path = outPath + "/" + GameConfig.GameName.ToLower() + "/version.txt";

        if (File.Exists(path))
        {
            File.Delete(path);
        }

        string content = JsonUtility.ToJson(version,true);
        File.WriteAllText(path, content);

        AssetDatabase.Refresh();
        Debug.Log("产生版本文件");
    }
    #endregion


    //一键打包
    [MenuItem("Tools/AB/一键打包")]
    static void QuickBuild()
    {
        MoveLuaToResources();
        ClearAssetBundlesName();
        MakeAssetBundleName();
        BuildAssetBundle();
        GenFileList();
        GenVersion();
    }

    [MenuItem("Tools/AB/清空persitent")]
    static void ClearPersistent()
    {
        DelectDir(Application.persistentDataPath);
    }
}
