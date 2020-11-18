Shader "Custom/CustomUV"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Speed("Speed",float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque"  }
        LOD 200

        CGPROGRAM

        #pragma surface surf Standard alpha:fade

        #pragma target 3.0

        sampler2D _MainTex;
        float _Speed;
        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float2 followTime = float2(0, _Speed) * _Time.y;
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex + followTime);
            o.Emission = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
