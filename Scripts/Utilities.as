#include "ScriptEngine/Plugins/BasePlugin.as"

const Vector4 RGBA_OPAQUE = Vector4(1.0f, 1.0f, 1.0f, 1.0f);
const Vector4 RGBA_TRANSPARENT = Vector4(1.0f, 1.0f, 1.0f, 0.0f);
const Vector3 ONES_VECTOR_3 = Vector3(1.0f, 1.0f, 1.0f);
const Vector2 ONES_VECTOR_2 = Vector2(1.0f, 1.0f);

const float EXP = 2.71828182846;
const float PI = 3.14159265359;

int FLIP_Y = 1;


namespace _utils_private
{

Material@ _getNodeMaterial(const Node@ node)
{
    if (node is null)
        return null;
    
    BillboardSet@ bbs = node.GetComponent("BillboardSet");
    
    if (bbs is null)
        return null;

    return bbs.material;
}

}


namespace Utils
{

/*
 * Read all textures into array `toArray` from a folder
 * with the first texture named `firstElementPath`.
 */
void ReadTexturesStartingWith(
    const String& firstElementPath,
    Array<Texture2D@> & toArray
) {
    toArray.Clear();

    String path = GetPath(firstElementPath);
    String file = GetFileName(firstElementPath);
    String extension = GetExtension(firstElementPath, false);
    
    String fileName = path + file + extension;
    Texture2D@ tex = cache.GetResource("Texture2D", fileName);
    if (tex !is null)
        toArray.Push(tex);
    else
        log.Error("Failed to load texture file '" + fileName + "'");

    for (uint i = 1; ; ++i)
    {
        fileName = path + file + String(i) + extension;
        if (cache.Exists(fileName))
        {
            tex = cache.GetResource("Texture2D", fileName);
            if (tex !is null)
                toArray.Push(tex);
            else
                log.Error("Failed to load texture file '" + fileName + "'");
        }
        else
        {
            break;
        }
    }
}


/*
 * Get Material from given `node`.
 */
Material@ GetNodeMaterial(Node@ node)
{
    Material@ material = _utils_private::_getNodeMaterial(node);
    if (material is null)
    {
        node.tags.length > 0
            ? log.Error("Failed to retreive material for node with 1st tag '" + node.tags[0] + "'")
            : log.Error("Failed to retreive material for node with unknown tags");
        return null;
    }
    return material;
}


/*
 * Get Material from node with given `nodeTag`.
 */
Material@ GetNodeMaterial(const String& nodeTag)
{
    Node@ node = scene.GetChildrenWithTag(nodeTag, true)[0];
    Material@ material = _utils_private::_getNodeMaterial(node);
    if (material is null)
    {
        log.Error("Failed to retreive material for node with given tag '" + nodeTag + "'");
        return null;
    }
    return material;
}


/*
 * Get Texture2D from given `node`.
 */
Texture2D@ GetNodeDiffuseTexture(Node@ node)
{
    Material@ material = GetNodeMaterial(node);
    if (material !is null)
        return material.textures[TU_DIFFUSE];
    return null;
}


/*
 * Get Texture2D from node with given `nodeTag`.
 */
Texture2D@ GetNodeDiffuseTexture(const String& nodeTag)
{
    Material@ material = GetNodeMaterial(nodeTag);
    if (material !is null)
        return material.textures[TU_DIFFUSE];
    return null;
}


/*
 * Get Texture2D from given `effect`
 */
Texture2D@ GetEffectTexture(MaskEngine::Mask@ mask, String effectTag)
{
    MaskEngine::BaseEffect@ effect = mask.GetEffectsByTag(effectTag)[0];
    if (effect is null)
    {
        log.Error("Failed to retreive texture for effect with tag '" + effectTag + "'");
        return null;
    }
    String textureFile = effect.GetTextureFile();
    Texture2D@ texture = cache.GetResource("Texture2D", textureFile);
    if (texture is null)
    {
        log.Error("Failed to retreive texture for effect with tag '" + effectTag + "'");
        return null;
    }
    return texture;
}


/*
 * Affect transparency of given `material`.
 */
void SetMaterialTransparency(Material@ material, float alpha)
{
    alpha = alpha > 1.0f ? 1.0f : alpha < 0.0f ? 0.0f : alpha;
    Vector4 rgba = material.shaderParameters["MatDiffColor"].GetVector4();
    rgba.w = alpha;
    material.shaderParameters["MatDiffColor"] = Variant(rgba);
}


void SetMaterialOpaque(Material@ material)
{
    if (material !is null)
        material.shaderParameters["MatDiffColor"] = Variant(RGBA_OPAQUE);
}


void SetMaterialTransparent(Material@ material)
{
    if (material !is null)
        material.shaderParameters["MatDiffColor"] = Variant(RGBA_TRANSPARENT);
}


void FadeInMaterial(
    Material@ material,
    const float speed = 1.0,
    const float opacity = 1.0,
    const bool fromTransparent = true
) {
    Vector4 initialColor = material.shaderParameters["MatDiffColor"].GetVector4();
    if (initialColor.w == opacity)
        return;
    ValueAnimation@ animation = ValueAnimation();
    animation.SetKeyFrame(0.0, Variant(Vector4(
        initialColor.x, initialColor.y, initialColor.z,
        fromTransparent ? 0.0 : initialColor.w
    )));
    animation.SetKeyFrame(1.0, Variant(Vector4(
        initialColor.x, initialColor.y, initialColor.z, opacity
    )));
    material.SetShaderParameterAnimation("MatDiffColor", animation, WM_ONCE, speed);
}

void FadeOutMaterial(
    Material@ material,
    const float speed = 1.0,
    const float opacity = 0.0,
    const bool fromOpaque = true
) {
    Vector4 initialColor = material.shaderParameters["MatDiffColor"].GetVector4();
    if (initialColor.w == opacity)
        return;
    ValueAnimation@ animation = ValueAnimation();
    animation.SetKeyFrame(0.0, Variant(Vector4(
        initialColor.x, initialColor.y, initialColor.z,
        fromOpaque ? 1.0 : initialColor.w
    )));
    animation.SetKeyFrame(1.0, Variant(Vector4(
        initialColor.x, initialColor.y, initialColor.z, opacity
    )));
    material.SetShaderParameterAnimation("MatDiffColor", animation, WM_ONCE, speed);
}


/*
 * Get effect with given `tag`.
 */
Array<MaskEngine::BaseEffect@> GetEffectsWithTag(
    Array<MaskEngine::BaseEffect@> effects,
    const String& effectTag
) {
    Array<MaskEngine::BaseEffect@> result;
    for (uint i = 0; i < effects.length; ++i)
    {
        MaskEngine::BaseEffect@ effect = effects[i];
        if (
            effect !is null && 
            effect.GetNode() !is null && 
            effect.GetNode().tags.Find(effectTag) != -1
        ) {
            result.Push(effect);
        }
    }
    return result;
}


/*
 * Shuffle array of 2D Textures inplace.
 */
void Shuffle(
    Array<Texture2D@> & array
) {
    SetRandomSeed(time.systemTime);
    uint len = array.length;
    for (uint i = len - 1; i > 0; i--)
    {
        uint j = RandomInt(0, i);
        Texture2D@ temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }
}

/*
 * Shuffle array of Strings inplace.
 */
void Shuffle(
    Array<String> & array
) {
    SetRandomSeed(time.systemTime);
    uint len = array.length;
    for (uint i = len - 1; i > 0; i--)
    {
        uint j = RandomInt(0, i);
        String temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }
}


/*
 * Generate array of random integers in a range.
 */
Array<uint> RandomIndices(uint length) {
    Array<uint> result;
    while (result.length != length)
    {
        uint idx = RandomInt(0, length);
        if (result.Find(idx) == -1)
            result.Push(idx);
    }
    return result;
}


Array<uint> NumberToDigits(uint number)
{
    Array<uint> arr;
    do
    {
        uint digit = number % 10;
        arr.Push(digit);
        number -= digit;
        number /= 10;
    }
    while (number != 0);
    return arr;
}


void NormalizedToScreen(const Vector2& fromPoint, Vector2& toPoint)
{
    toPoint.x = (fromPoint.x - 0.5f) * ScreenInfo.resolution.x;
    toPoint.y = (fromPoint.y - 0.5f) * ScreenInfo.resolution.y * FLIP_Y;
    if (GetPlatform() == "iOS")
        toPoint.y *= toPoint.y < 0 ? 1.15 : 1.1;
}


/*
 *  For compatibility with mobile devices... :(
 *  Existing `Dictionary` class leads to crashes on
 *  mobile devices.
 * 
 *  Keys are Strings, values are Variants.
 */
class Dictionary
{
    Array<String> keys;
    // Array<String> values;
    Array<Variant> values;

    uint length {
        get const { return keys.length; }
    }

    void Set(const String& key, const Variant& value)
    {
        int index = keys.Find(key);
        if (index == -1)
        {
            keys.Push(key);
            values.Push(value);
        }
        else
        {
            values[index] = value;
        }
    }

    void Get(const String& key, Variant& value) const
    {
        int index = keys.Find(key);
        if (index == -1)
        {
            log.Error("Utils::Dictionary - key doesn't exist");
            return;
        }
        value = values[index];
    }
}


/*
 *
 */
Texture2D@ CreateRenderTargetTexture(
    const Vector2& dimensions,
    const String& name
) {
    Texture2D@ texture = cache.GetResource("Texture2D", name, false);
    if (texture !is null)
    {
        log.Warning("Resource of type 'Texture2D' with name '" + name + "' already exists");
        return texture;
    }

    Texture2D@ texure = Texture2D();
    texure.SetSize(
        uint(dimensions.x),
        uint(dimensions.y),
        GetRGBAFormat(),
        TEXTURE_RENDERTARGET
    );
    texure.name = name;
    cache.AddManualResource(texure);
    return texure;
}

/*
 *  
 */
String AddRenderPath(
    const String shaderName,
    const Dictionary shaderParams,
    const String sourceTexturePath,
    const String maskTexturePath,
    const String renderTargetName,
    const bool append = false
) {
    String dummy = "<!-- -->";
    String rpString = 
        "<renderpath>\n"
        "    <command type=\"quad\" vs=\"{{ shader }}\" ps=\"{{ shader }}\" output=\"{{ render_target }}\">\n"
        "        <texture unit=\"environment\" name=\"{{ texture_path }}\" />\n"
        "        <texture unit=\"diffuse\" name=\"{{ mask_texture_path }}\" />\n"
        "        " + dummy + "\n"
        "    </command>\n"
        "</renderpath>\n";

    rpString.Replace("{{ shader }}", shaderName);
    rpString.Replace("{{ texture_path }}", sourceTexturePath);
    rpString.Replace("{{ mask_texture_path }}", maskTexturePath);
    rpString.Replace("{{ render_target }}", renderTargetName);

    for (uint i = 0; i < shaderParams.length; ++i)
    {
        String key = shaderParams.keys[i];
        Variant v = Variant(); shaderParams.Get(key, v);
        String value = v.GetString();
        rpString.Replace(
            dummy,
            ("<parameter name=\"" + key + "\" value=\"" + value + "\" />\n        " + dummy)
        );
    }

    if (append)
    {
        XMLFile@ maskXMLFile = XMLFile();
        maskXMLFile.FromString(rpString);
        RenderPath@ defaultRp = renderer.viewports[0].renderPath;
        defaultRp.Append(maskXMLFile);
    }

    return rpString;
}


void SetTextEffect(
    const String& tag,
    const String& text
) {
    Array<Node@> nodes = scene.GetChildrenWithTag(tag, true);
    if (nodes.empty || nodes[0] is null)
    {
        log.Error("text effect not found");
        return;
    }
    nodes[0].name = text;
    nodes[0].temporary = true;
}

float BihFilter(float new, float old, float k)
{
    return k * new + (1 - k) * old;
}


float Lerp(float x, float x1, float x2, float y1, float y2)
{
    return y1 + (y2 - y1) * (x / (x2 - x1));
}


float DistanceSquared(const Vector3& a, const Vector3& b)
{
    return Pow(a.x - b.x, 2) + Pow(a.y - b.y, 2) + Pow(a.z - b.z, 2);
}

float DistanceSquared(const Vector2& a, const Vector2& b)
{
    return Pow(a.x - b.x, 2) + Pow(a.y - b.y, 2);
}

float Distance(const Vector3& a, const Vector3& b)
{
    return Sqrt(DistanceSquared(a, b));
}

float Distance(const Vector2& a, const Vector2& b)
{
    return Sqrt(DistanceSquared(a, b));
}

float Tanh(float x)
{
    float e = Pow(EXP, 2 * x);
    return (e - 1) / (e + 1);
}

}
