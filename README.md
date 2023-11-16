# mask-template

A template for a VK Mask project.

## Main Script

In order to use `ScreenInfo` object right after the beginning of the mask, we need to skip the first frame for `ScreenInfoProvider` to initialize its members with real values.

To implement this behaviour, you can follow this pattern:

1. Define a function, which purpose is to be called only once at the first frame and call another function where you can do the rest of initialization:

   ```AngelScript
   void FirstFrame(StringHash eventType, VariantMap& eventData)
   {
       UnsubscribeFromEvent("PostUpdate");
       InitAfterFirstFrame();
   }
   ```

2. Subscribe to this function in `Init` or `InitWithEffects`:

   ```AngelScript
   SubscribeToEvent("PostUpdate", "FirstFrame");
   ```

3. Do the rest of initialization with screen info:
   ```AngelScript
   void InitAfterFirstFrame()
   {
       // ScreenInfo now has its members properly initialized
   }
   ```

## Shaders

List of vailable fragment shader uniforms:

```glsl
uniform vec4 cAmbientColor;
uniform vec3 cCameraPosPS;
uniform float cDeltaTimePS;
uniform vec4 cDepthReconstruct;
uniform float cElapsedTimePS;
uniform vec4 cFogParams;
uniform vec3 cFogColor;
uniform vec2 cGBufferInvSize;
uniform vec4 cLightColor;
uniform vec4 cLightPosPS;
uniform vec3 cLightDirPS;
uniform vec4 cNormalOffsetScalePS;
uniform vec4 cMatDiffColor;
uniform vec3 cMatEmissiveColor;
uniform vec3 cMatEnvMapColor;
uniform vec4 cMatSpecColor;
uniform vec2 cFrameUpPS;
uniform vec2 cFrameRightPS;
uniform vec4 cFrameSizeInvSizePS;
uniform vec2 cFrameAspectRatio;
uniform float cRoughness;
uniform float cMetallic;
uniform float cNearClipPS;
uniform float cFarClipPS;
uniform vec4 cShadowCubeAdjust;
uniform vec4 cShadowDepthFade;
uniform vec2 cShadowIntensity;
uniform vec2 cShadowMapInvSize;
uniform vec4 cShadowSplits;
uniform mat4 cLightMatricesPS[4];
uniform vec2 cVSMShadowParams;
```
