#include "Scripts/Utilities.as"


class TouchGesturesProvider
{
    String tapEventName
    {
        get const { return m_tapEventName; }
    }

    Vector2 lastTouchPosition
    {
        get const { return m_lastGesturePosition; }
    }

    TouchGesturesProvider()
    {
        m_kwargs = VariantMap();
        m_tapEventName = "UserTappedEvent";
        m_lastGesturePosition = Vector2();
        SubscribeToEvent("MouseEvent", "HandleMouseEvent");
    }

    private VariantMap m_kwargs;
    private String m_tapEventName;
    private Vector2 m_lastGesturePosition;

    private void HandleMouseEvent(StringHash eventType, VariantMap& eventData)
    {
        if (eventData["Event"].GetString() == "tap")
        {
            Vector2 normalizedPosition = eventData["Position"].GetVector2();
            Utils::NormalizedToScreen(normalizedPosition, m_lastGesturePosition);

            m_kwargs["NormalizedPosition"] = normalizedPosition;
            m_kwargs["ScreenPosition"] = m_lastGesturePosition;
            SendEvent(m_tapEventName, m_kwargs);
        }
    }
}

TouchGesturesProvider@ TouchGestures;
