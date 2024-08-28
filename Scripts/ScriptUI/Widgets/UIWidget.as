enum UIWidgetPositioning
{
    CENTER,
    BOTTOM_CENTER,
    TOP_CENTER,
    RIGHT_CENTER,
    LEFT_CENTER,
    LT_CORNER,
    LB_CORNER,
    RT_CORNER,
    RB_CORNER
}


interface UIWidgetInterface : ScriptObject
{
    String              name        { get const; set; }
    Vector2             position    { get const; set; }
    Vector2             size        { get const; set; }
    UIWidgetPositioning positioning { get const; set; }

    bool IntersectsWith(Vector2 point);
}


class UIWidget : UIWidgetInterface
{
    String name
    {
        get const { return m_name; }
        set
        {
            m_name = value;
            m_kwargs["Sender"] = m_name;
        }
    }

    Vector2 position
    {
        get const { return m_position; }
        set
        {
            m_position = value;
            CorrectPosition();
        }
    }

    Vector2 size
    {
        get const { return m_halfSize * 2.0f; }
        set { m_halfSize = value * 0.5f; }
    }

    UIWidgetPositioning positioning
    {
        get const { return m_positioning; }
        set
        {
            m_positioning = value;
            CorrectPosition();
        }
    }

    bool IntersectsWith(Vector2 point)
    {
        if (
            point.x > m_position.x - m_halfSize.x &&
            point.x < m_position.x + m_halfSize.x &&
            point.y > m_position.y - m_halfSize.y &&
            point.y < m_position.y + m_halfSize.y
        )
            return true;
        return false;
    }

    UIWidget()
    {
        m_name = "default_widget_name";
        m_positioning = UIWidgetPositioning::CENTER;
        m_position = Vector2(0.0f, 0.0f);
        m_kwargs["Sender"] = m_name;
    }

    protected String m_name;
    protected Vector2 m_position;
    protected Vector2 m_halfSize;
    protected VariantMap m_kwargs;
    protected UIWidgetPositioning m_positioning;

    private void CorrectPosition()
    {
        if (m_positioning == UIWidgetPositioning::BOTTOM_CENTER)
            m_position.y -= ScreenInfo.resolution.y * 0.5f;
        else if (m_positioning == UIWidgetPositioning::TOP_CENTER)
            m_position.y += ScreenInfo.resolution.y * 0.5f;
    }
}
