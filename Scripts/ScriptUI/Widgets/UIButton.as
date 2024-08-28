#include "Scripts/ScriptUI/Widgets/UIWidget.as"


class UIButton : UIWidget
{
    UIButton()
    {
        m_name = "default_button_name";
        m_kwargs["Sender"] = m_name;
    }
}
