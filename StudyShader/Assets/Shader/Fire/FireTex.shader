Shader "Custom/FireTex"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _SubTex("Albedo (RGB)", 2D) = "white" {}
        _Speed("Speed",float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent"  "Queue"="Transparent" }
        LOD 200

        CGPROGRAM
       
        #pragma surface surf Standard alpha:fade

        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _SubTex;

        float _Speed;
        float _Noise;
        struct Input
        {
            float2 uv_MainTex;
            float2 uv_SubTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float2 followTime = float2(0, _Speed) * _Time.y;
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            fixed4 d = tex2D(_SubTex, IN.uv_SubTex - followTime);
            o.Emission = c.rgb * d.rgb;
            o.Alpha = c.a * d.a;

        }
        ENDCG
    }
    FallBack "Diffuse"
}
