Shader "Custom/CameraDistanceDither"
{
    Properties
    {
        _MainTex ("Base Texture", 2D) = "white" { }
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MaxDitherDistance ("Max Dither Distance", Float) = 10.0
        _MinDitherDistance ("Min Dither Distance", Float) = 2.0
    }

    SubShader
    {
        Tags
        {
            "Queue"="Overlay" "RenderType"="Opaque" "LightMode"="UniversalForward"
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "dither.cginc" //相对路径

            sampler2D _MainTex;

            uniform half4 _Color;

            struct appdata_t
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
            };

            struct v2f
            {
                float4 pos : POSITION;
                float2 uv : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                float4 screenPos: TEXCOORD2;
            };

            v2f vert(appdata_t v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.screenPos = ComputeScreenPos(o.pos);
                return o;
            }

            // Fragment shader
            float4 frag(v2f i) : SV_Target
            {
                float ditherResult = Dither(i.screenPos);
                float4 color = tex2D(_MainTex, i.uv);
                color *= _Color;
                clip(ditherResult == 0 ? -1 : ditherResult);
                return color;
            }
            ENDCG
        }
    }

    FallBack "Diffuse"
}