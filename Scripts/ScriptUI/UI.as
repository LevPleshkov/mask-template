#include "Scripts/ScriptUI/UIConstants.as"
#include "Scripts/ScriptUI/UIController.as"


class UI
{
    void AddWidget(UIWidget@ widget)
    {
        m_controller.AddWidget(widget);
    }
 
    UI()
    {
        @m_controller = cast<UIController>(scene.CreateScriptObject(scriptFile, "UIController", LOCAL));
    }

    private UIController@ m_controller;
}
