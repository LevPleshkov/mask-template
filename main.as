#include "ScriptEngine/Effects/Base/BaseEffect.as"
#include "Scripts/Providers/ScreenInfoProvider.as"
#include "Scripts/Providers/TouchGesturesProvider.as"
#include "Scripts/Utilities.as"


Array<MaskEngine::BaseEffect@> effects;


void Init()
{
    @ScreenInfo = ScreenInfoProvider();
    @TouchGestures = TouchGesturesProvider();
}


void InitWithEffects(VariantMap dataMap)
{
    Array<Variant> variants = dataMap["effects"].GetVariantVector();
    for (uint i = 0; i < variants.length; i++)
        effects.Push(
            cast<MaskEngine::BaseEffect>(variants[i].GetScriptObject())
        );
}
