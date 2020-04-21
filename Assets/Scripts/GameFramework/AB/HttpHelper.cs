using UnityEngine;
using UnityEngine.Networking;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;

//负责http请求
public class HttpHelper : MonoSingleton<HttpHelper>
{
    //下载文件
    public void DownLoadFile(string path,Action<bool> action)
    {
        string url = GameConfig.GetResUrl(path);
        string filename = GameConfig.GetPersitentPath(path);
        if (File.Exists(filename))
            File.Delete(filename);
        StartCoroutine(CoDownLoadFile(url, filename, action));
    }

    IEnumerator CoDownLoadFile(string url,string filename,Action<bool> action)
    {
        UnityWebRequest downloader = UnityWebRequest.Get(url);
        string dir = FileHelper.GetDir(filename);
        if (!Directory.Exists(dir))
        {
            Directory.CreateDirectory(dir);
        }
        DownloadHandlerFile downloadHandlerFile =  new DownloadHandlerFile(filename);
        downloadHandlerFile.removeFileOnAbort = true; //TODO 定点续传等
        downloader.downloadHandler = downloadHandlerFile;

        downloader.SendWebRequest();
        while (!downloader.isDone)
        {
            yield return null;
        }

        if (downloader.error != null)
        {
            Debug.LogError(downloader.error);
            action(false);
        }
        else
        {
            action(true);
        }  
    }
}