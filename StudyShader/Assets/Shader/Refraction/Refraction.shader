Shader "Custom/Refraction"
{
    Properties
    {
        _Noise("Noise", 2D) = "white"{}
        _NoisePower("NoisePower", Range(0,0.1)) = 0.05
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        zwrite off
        cull off

        GrabPass{}

        CGPROGRAM
        #pragma surface surf nolight noambient alpha:fade

        sampler2D _GrabTexture;
        sampler2D _Noise;
        float _NoisePower;
        struct Input
        {
            float4 color:COLOR;
            float4 screenPos;

            float2 uv_Noise;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            float4 n = tex2D(_Noise, IN.uv_Noise);
            float3 screenUV = IN.screenPos.rgb / IN.screenPos.a;
            o.Emission = tex2D(_GrabTexture, screenUV.xy + n.x * _NoisePower);
        }

        float4 Lightingnolight(SurfaceOutput s, float lightDir, float atten)
        {
            return float4(0, 0, 0, 1);
        }

        ENDCG
    }
        FallBack "Regacy Shaders/Transparent/Vertexlit"
}
