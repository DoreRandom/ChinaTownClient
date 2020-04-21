using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using System.Collections.Generic;
using System;

namespace Game
{
    /// <summary>
    /// 这里仅仅实现单页面通知
    /// </summary>
    public class NotifyView
    {
        Text m_Title;
        Text m_Content;
        Button m_Button1;
        Text m_Text1;
        Button m_Button2;
        Text m_Text2;

        private GameObject m_Go = null;
        private GameObject m_NotifyTwo;
        public NotifyView(GameObject go)
        {
            this.m_Go = go;
            GameObjectContainer container = go.GetComponent<GameObjectContainer>();
            if (container == null) { return; }
            m_NotifyTwo = container.Get(2);

            if (m_NotifyTwo == null) { return; }
            container = m_NotifyTwo.GetComponent<GameObjectContainer>();
            m_Title = container.GetUI<Text>(1);
            m_Content = container.GetUI<Text>(2);
            m_Button1 = container.GetUI<Button>(3);
            m_Text1 = container.GetUI<Text>(4);
            m_Button2 = container.GetUI<Button>(5);
            m_Text2 = container.GetUI<Text>(6);
        }


        public void Notify(string title,string content,Action action1,string text1,Action action2,string text2)
        {
            m_Title.text = title;
            m_Content.text = content;

            m_Text1.text = text1;
            m_Text2.text = text2;

            m_Button1.onClick.RemoveAllListeners();
            m_Button1.onClick.AddListener(()=> {  action1(); });

            m_Button2.onClick.RemoveAllListeners();
            m_Button2.onClick.AddListener(() => { action2(); });

            m_NotifyTwo.SetActive(true);
        }


        //隐藏
        public void Hide()
        {
            m_NotifyTwo.SetActive(false);
        }

        public void Destroy()
        {
            if (m_Go != null)
                GameObject.Destroy(m_Go);
        }
    }
}