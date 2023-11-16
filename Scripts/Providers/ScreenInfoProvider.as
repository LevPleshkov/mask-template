class ScreenInfoProvider
{
    Vector2 resolution
    {
        get const { return m_screenSize; }
    }

    bool isFrontCamera
    {
        get const { return m_isFrontCamera; }
    }

    ScreenInfoProvider()
    {
        Print("ScreenInfoProvider");
        SubscribeToEvent("SrcFrameUpdate", "HandleSrcFrameUpdate");
    }

    private Vector2 m_screenSize;
    private bool m_isFrontCamera;

    private void HandleSrcFrameUpdate(StringHash eventType, VariantMap& eventData)
    {
        m_screenSize = eventData["Size"].GetVector2();
        m_isFrontCamera = eventData["IsFrontCamera"].GetBool();
    }
}

ScreenInfoProvider@ ScreenInfo;
