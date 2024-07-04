class HeadGesturesProvider
{
    String headTiltEventName
    {
        get const { return m_headTiltEventName; }
    }

    float resetWidth
    {
        get const { return 2.0 * m_resetHalfWidth; }
        set { m_resetHalfWidth = 0.5 * value; }
    }

    float bufferWidth
    {
        get const { return m_bufferWidth; }
        set { m_bufferWidth = value; }
    }

    String previousZone
    {
        get const { return m_prevZone; }
    }

    String currentZone
    {
        get const { return m_currZone; }
    }

    HeadGesturesProvider()
    {
        m_headTiltEventName = "HeadTiltedToNewZone";
        m_resetHalfWidth = 8.0;
        m_bufferWidth = 10.0;
        m_prevZone = "reset";
        m_currZone = "reset";
        m_kwargs = VariantMap();
        SubscribeToEvent("UpdateFaceDetected", "HandleUpdateFaceDetected");
    }

    private String m_headTiltEventName;

    private VariantMap m_kwargs;

    private float m_resetHalfWidth;
    private float m_bufferWidth;

    private String m_prevZone;
    private String m_currZone;

    private void HandleUpdateFaceDetected(StringHash eventType, VariantMap& eventData)
    {
        if (eventData["Detected"].GetBool())
        {
            m_prevZone = m_currZone;
            m_currZone = ResolveHeadTilt(
                eventData["NFace"].GetUInt()
            );

            if (m_prevZone != m_currZone)
            {
                SendEvent(m_headTiltEventName);
            }
        }
    }

    private String ResolveHeadTilt(const uint nFace)
    {
        Node@ faceNode = scene.GetChild("Face" + (nFace == 1 ? "1" : ""));
        float headTilt = faceNode.worldRotation2D;

        if (Abs(headTilt) <= m_resetHalfWidth)
        {
            return "reset";
        }
        else if (
            Abs(headTilt) > m_resetHalfWidth &&
            Abs(headTilt) < m_resetHalfWidth + m_bufferWidth
        ) {
            return "buffer";
        }
        else
        {
            if (headTilt < (m_bufferWidth + m_resetHalfWidth))
                return "right";
            if (headTilt > -(m_bufferWidth + m_resetHalfWidth))
                return "left";
            return "";
        }
    }
}

HeadGesturesProvider@ HeadGestures;
