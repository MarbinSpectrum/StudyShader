Shader "Custom/Dissolve"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _NoiseTex("NoiseTex", 2D) = "white" {}
        _Cut("Alpha Cut", Range(0,0.045)) = 0
        _BlackOutThinkness("BlackOutThinkness", Range(1,1.5)) = 1
        [HDR]_FireColor("FireColor",Color) = (1,1,1,1)
        _FireOutThinkness("FireOutThinkness",  Range(1,1.5)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Lambert alpha:fade

        sampler2D _MainTex;
        sampler2D _NoiseTex;
        float _Cut;
        float _BlackOutThinkness;
        float4 _FireColor;
        float _FireOutThinkness;
        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NoiseTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 m = tex2D (_MainTex, IN.uv_MainTex);
            float4 n = tex2D (_NoiseTex, IN.uv_NoiseTex);
            float cut = 0.045 * max(0, cos(_Time.y));
            if(n.r >= _Cut)
                o.Alpha = 1;
            else
                o.Alpha = 0;

            if (n.r >= _Cut * _BlackOutThinkness)
                o.Albedo = m.rgb;
            else if (n.r >= _Cut * _FireOutThinkness)
                o.Emission = _FireColor.rgb;
            else
                o.Albedo = float3(0, 0, 0);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
