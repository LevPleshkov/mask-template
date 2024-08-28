#include "Scripts/Providers/TouchGesturesProvider.as"


class UIController : ScriptObject
{
    void AddWidget(UIWidget@ widget)
    {
        if (widget !is null)
            m_widgets.Push(widget);
    }

    UIController()
    {
        if (TouchGestures is null)
            @TouchGestures = TouchGesturesProvider();

        if (ScreenInfo is null)
            @ScreenInfo = ScreenInfoProvider();

        if (GetPlatform() == "Mac OS X")
            FLIP_Y = -1;

        m_kwargs["Sender"] = UICONTROLLER_SENDER_NAME;
        m_lastTapPositioin = Vector2();

        // SubscribeToEvent(TouchGestures.tapEventName, "HandleTapEvent");
    }

    private Array<UIWidget@> m_widgets;
    private VariantMap m_kwargs;
    private Vector2 m_lastTapPositioin;

    // void HandleTapEvent(StringHash eventType, VariantMap& eventData)
    // {
    //     for (uint i = 0; i < m_widgets.length; ++i)
    //     {
    //         UIWidget@ widget = m_widgets[i];
    //         if (widget.IntersectsWith(TouchGestures.lastTouchPosition))
    //         {
    //             m_kwargs["Sender"] = widget.name;
    //             SendEvent(UIWIDGET_TAPPED_EVENT, m_kwargs);
    //         }
    //     }
    // }
}
