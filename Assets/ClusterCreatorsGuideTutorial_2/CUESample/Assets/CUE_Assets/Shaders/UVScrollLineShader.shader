Shader "CUE/UVScrollLineShader"
{
    Properties
    {
        _LineColor ("Line Color", Color) = (0, 1, 0, 1)
        _Speed("Scroll Speed", Range(-200.0, 200.0)) = 12.0
        _LineNum("Line Num", Range(1.0, 64.0)) = 16.0
        _HiddenLineNum("Hidden Line Num", Range(0.0, 64.0)) = 0.0
        _ColorTimes("Color Times", Range(0.0, 5.0)) = 1.0
        [Toggle] _CenterWhite("Center is White", float) = 1.0
        [KeywordEnum(Vertical, Horizontal)]_LineType("Line Type", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        Cull Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile _LINETYPE_VERTICAL _LINETYPE_HORIZONTAL

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            half4 _LineColor;
            half _Speed;
            half _ColorTimes;
            half _LineNum;
            half _HiddenLineNum;
            half _CenterWhite;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            half4 frag (v2f i) : SV_Target
            {
                #ifdef _LINETYPE_VERTICAL
                    i.uv.y += _Speed * _Time;
                    half sinVal = sin(i.uv.y * _LineNum*6.283);
                    half skipVal = frac(i.uv.y)*_LineNum;
                #else
                    i.uv.x += _Speed * _Time;
                    half sinVal = sin(i.uv.x * _LineNum*6.283);
                    half skipVal = frac(i.uv.x)*_LineNum;
                #endif

                clip(skipVal-_HiddenLineNum);
                half colVal = step(0.5, sinVal);

                clip(colVal-0.5);

                half4 col = lerp(_LineColor,half4(1,1,1,1),step(0.93, sinVal)*_CenterWhite);
                col += col*_ColorTimes;


                return col;

            }
            ENDCG
        }
    }
}
