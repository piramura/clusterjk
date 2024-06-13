Shader "CUE/UVScrollDiffuseShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MultiplyColor ("Multiply Color", Color) = (0.5, 0.5, 0.5, 1)
        _LightColor ("Light Color", Color) = (1, 1, 1, 1)
        _LightPower("Light Power", Range(0.0, 10.0)) = 1.0
        _ColorTimes("Color Times", Range(0.0, 10.0)) = 1.0
        _XSpeed("Scroll Speed(X)", Range(-200.0, 200.0)) = 12.0
        _YSpeed("Scroll Speed(Y)", Range(-200.0, 200.0)) = 6.0
        [Toggle] _ColorTimesMaskScroll("Color Times Mask Scrolls", float) = 1.0
        _ColorTimesMaskTex ("Color Times Mask Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal:NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                fixed4 diff : COLOR0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _ColorTimesMaskTex;
            float4 _ColorTimesMaskTex_ST;
            
            half4 _MultiplyColor;
            half4 _LightColor;
            half _XSpeed;
            half _YSpeed;
            half _ColorTimes;
            half _LightPower;
            half _ColorTimesMaskScroll;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                half3 worldNormal = UnityObjectToWorldNormal(v.normal);
                half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
                o.diff = nl * _LightColor;
                o.diff.rgb += ShadeSH9(half4(worldNormal,1));
                return o;
            }

            half4 frag (v2f i) : SV_Target
            {
                half2 uvScroll;
                uvScroll.x = _XSpeed * _Time;
                uvScroll.y = _YSpeed * _Time;

                half4 col = tex2D(_MainTex, i.uv+uvScroll)*_MultiplyColor;

                fixed4 colMask= tex2D(_ColorTimesMaskTex, i.uv+uvScroll*_ColorTimesMaskScroll);
                col += col*_ColorTimes*colMask;
                col += i.diff*_LightPower;

                return col;
            }
            ENDCG
        }
    }
}
