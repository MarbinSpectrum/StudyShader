Shader "Custom/FireTex"
{
    Properties
    {
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _MessTex("Albedo (RGB)", 2D) = "white" {}
        _Speed("Speed",float) = 1
        _Noise("Noise",float) = 1
    }
        SubShader
        {
            Tags { "RenderType" = "Transparent"  "Queue" = "Transparent" }
            LOD 200

            CGPROGRAM

            #pragma surface surf Standard alpha:fade

            #pragma target 3.0

            sampler2D _MainTex;
            sampler2D _MessTex;
            float _Speed;
            float _Noise;
            struct Input
            {
                float2 uv_MainTex;
                float2 uv_SubTex;
                float2 uv_MessTex;
            };

            void surf(Input IN, inout SurfaceOutputStandard o)
            {
                float2 followTime = float2(0, _Speed) * _Time.y;
                fixed4 b = tex2D(_MessTex, IN.uv_MessTex - followTime);
                fixed4 c = tex2D(_MainTex, IN.uv_MainTex + b.r * _Noise);
                o.Emission = c.rgb;
                o.Alpha = c.a;

            }
            ENDCG
        }
            FallBack "Diffuse"
}
