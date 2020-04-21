using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;

public class UIEventHandler : MonoBehaviour, IPointerClickHandler, IPointerEnterHandler, IPointerExitHandler, IPointerDownHandler, IDragHandler
{
    public Action<PointerEventData> onClick = null;
    public Action<PointerEventData> onEnter = null;
    public Action<PointerEventData> onExit = null;
    public Action<PointerEventData> onDown = null;
    public Action<PointerEventData> onDrag = null;

    public void OnPointerClick(PointerEventData eventData)
    {
        if (onClick != null)
            onClick(eventData);
    }

    public void OnPointerEnter(PointerEventData eventData)
    {
        if (onEnter != null)
            onEnter(eventData);
    }

    public void OnPointerExit(PointerEventData eventData)
    {
        if (onExit != null)
            onExit(eventData);
    }

    public void OnPointerDown(PointerEventData eventData)
    {
        if (onDown != null)
            onDown(eventData);
    }

    public void OnDrag(PointerEventData eventData)
    {
        if (onDrag != null)
            onDrag(eventData);
    }

}