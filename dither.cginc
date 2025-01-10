
// #include "UnityCG.cginc"
float _MaxDitherDistance; // Maximum distance for dithering effect
float _MinDitherDistance; // Minimum distance for dithering effect

static float ditherMatrix[8][8] = {
    0., 32., 8., 40., 2., 34., 10., 42.,
    48., 16., 56., 24., 50., 18., 58., 26.,
    12., 44., 4., 36., 14., 46., 6., 38.,
    60., 28., 52., 20., 62., 30., 54., 22.,
    3., 35., 11., 43., 1., 33., 9., 41.,
    51., 19., 59., 27., 49., 17., 57., 25.,
    15., 47., 7., 39., 13., 45., 5., 37.,
    63., 31., 55., 23., 61., 29., 53., 21.
};

//获取中心点到相机的距离
float GetDistanceFromCenterToCamera()
{
    float3 center = unity_ObjectToWorld._14_24_34;
    float3 cameraPosition = _WorldSpaceCameraPos;
    float distance = length(center - cameraPosition);
    return distance;
}

float2 GetScreenPos(float4 screenPos)
{
    float2 pos = screenPos.xy / screenPos.w * _ScreenParams.xy;
    return pos;
}

// Function to calculate dithering based on distance
float Dither(float4 screenPos)
{
    float2 pos = GetScreenPos(screenPos);
    // Map the distance to a dithering intensity (clamped between 0 and 1)
    float ditherIntensity = smoothstep(_MinDitherDistance, _MaxDitherDistance, GetDistanceFromCenterToCamera());

    // Normalize the intensity: close objects have stronger dithering, farther objects have weaker dithering
    float threshold = ditherIntensity;

    int size = 8;
                
    // Normalize Bayer matrix value (0 to 1) and apply the threshold
    // float ditherValue = DITHER_THRESHOLDS[index];
    float ditherValue = ditherMatrix[pos.x % size][pos.y % size] / (size * size);

    // Return the final dithering effect after threshold application
    return threshold - ditherValue;
}