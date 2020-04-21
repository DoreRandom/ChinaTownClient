using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using UnityEngine;


public class FileHelper
{
    //获得文件的md5
    public static string GetMD5HashFromFile(string fileName)
    {
        try
        {
            FileStream file = new FileStream(fileName, FileMode.Open);
            System.Security.Cryptography.MD5 md5 = new System.Security.Cryptography.MD5CryptoServiceProvider();
            byte[] retVal = md5.ComputeHash(file);
            file.Close();

            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < retVal.Length; i++)
            {
                sb.Append(retVal[i].ToString("x2"));
            }
            return sb.ToString();
        }
        catch (Exception ex)
        {
            Debug.LogError(ex.Message);
            return "";
        }
    }

    //unix path

    //转为unix路径
    public static string UnixPath(string s)
    {
        return s.Replace("\\", "/");
    }



    //获得文件夹路径
    public static string GetDir(string path)
    {
        int index = path.LastIndexOf("/");
        string ret = path.Substring(0, index);
        return ret;
    }
}