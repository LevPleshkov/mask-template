#include "Scripts/ScriptUI/UI.as"
#include "Scripts/ScriptUI/Widgets/UIButton.as"


/**
 *  Patch size in mask.json is received as half-size.
 */


UI gui;
UIButton@ exampleButton;


void InitGui()
{
    gui = UI();

    @exampleButton = CreateButton();
    exampleButton.name = "example";
    exampleButton.positioning = UIWidgetPositioning::BOTTOM_CENTER;
    exampleButton.position = Vector2(-ScreenInfo.resolution.x * 0.3, ScreenInfo.resolution.y * 0.36);
    exampleButton.size = Vector2(ScreenInfo.resolution.x * 0.125, ScreenInfo.resolution.x * 0.125);
    gui.AddWidget(exampleButton);
}


UIButton CreateButton()
{
    return cast<UIButton>(
        scene.CreateScriptObject(scriptFile, "UIButton", LOCAL)
    );
}
