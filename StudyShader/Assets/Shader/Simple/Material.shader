Shader "Custom/Material"
{
    Properties
    {
        _Color("Color",Color) = (1,1,1)
        _Darkness("Darkness", Range(-1, 1)) = 0
    }
        SubShader
        {
            Tags { "RenderType" = "Opaque" }
            LOD 200

            CGPROGRAM
            #pragma surface surf Standard fullforwardshadows

            #pragma target 3.0

            float3 _Color;
            float _Darkness;

            struct Input
            {
                float2 uv_MainTex;
            };

            void surf(Input IN, inout SurfaceOutputStandard o)
            {           
                o.Emission = _Color.rgb + _Darkness;
            }
            ENDCG
        }
    FallBack "Diffuse"
}
