using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using System.Collections.Generic;
using System;

namespace Game
{
    public class InitView
    {
        private Text m_TitleText = null;
        private Image m_ProgressImg = null;
        private Text m_DetailText = null;
        private Text m_VersionText = null;

        private GameObject m_Go = null;
        
        public InitView(GameObject go)
        {
            this.m_Go = go;
            GameObjectContainer container = go.GetComponent<GameObjectContainer>();
            if (container == null) { return; }

            m_TitleText = container.GetUI<Text>(1);
            m_ProgressImg = container.GetUI<Image>(2);
            m_DetailText = container.GetUI<Text>(3);
            m_VersionText = container.GetUI<Text>(4);
        }

        //设置title
        public void SetTitle(string title)
        {
            if (m_TitleText != null)
                m_TitleText.text = title;
        }

        //设置进度
        public void SetProgress(float progress)
        {
            if (m_ProgressImg != null)
                m_ProgressImg.fillAmount = progress;
        }

        //设置具体信息
        public void SetDetail(string msg)
        {
            if (m_DetailText != null)
                m_DetailText.text = msg;
        }

        //版本信息
        public void SetVersion(string version)
        {
            string v = String.Format("Version:{0}", version);
            if (m_VersionText != null)
                m_VersionText.text = v;
        }

        public void Destroy()
        {
            if (m_Go != null)
                GameObject.Destroy(m_Go);
        }
    }
}