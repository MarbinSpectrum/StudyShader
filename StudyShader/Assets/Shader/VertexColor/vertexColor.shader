Shader "Custom/vertexColor"
{
    Properties
    {
        _Ground("Albedo (RGB)", 2D) = "white" {}
        _BumpMap("_NormalMap",2D) = "bump" {}
        _BumpValue("BumpValue",Range(0,1)) = 0.5
        _Metallic("Metallic",Range(0,1)) = 0
        _Smoothness("Smoothness",Range(0,1)) = 0.5

        _Grass0("Albedo (RGB)", 2D) = "white" {}
        _Grass1("Albedo (RGB)", 2D) = "white" {}
        _Grass2("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
      
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _Ground;
        sampler2D _Grass0;
        sampler2D _Grass1;
        sampler2D _Grass2;

        sampler2D _BumpMap;
        float _BumpValue;
        float _Metallic;
        float _Smoothness;

        struct Input
        {
            float2 uv_Ground;
            float2 uv_Grass0;
            float2 uv_Grass1;
            float2 uv_Grass2;
            float2 uv_BumpMap;
            float4 color:COLOR;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 ground = tex2D (_Ground, IN.uv_Ground);
            fixed4 grass0 = tex2D(_Grass0, IN.uv_Grass0);
            fixed4 grass1 = tex2D(_Grass1, IN.uv_Grass1);
            fixed4 grass2 = tex2D(_Grass2, IN.uv_Grass2);
            o.Emission = ground.rgb;
            o.Emission = lerp(o.Emission, grass0.rgb, IN.color.r);
            o.Emission = lerp(o.Emission, grass1.rgb, IN.color.g);
            o.Emission = lerp(o.Emission, grass2.rgb, IN.color.b);
            //o.Emission =
            //    grass0.rgb * IN.color.r +
            //    grass1.rgb * IN.color.g +
            //    grass2.rgb * IN.color.b +
            //    ground.rgb * (1 - IN.color.r - IN.color.g - IN.color.b);
            float3 n = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            o.Normal = float3(n.r * _BumpValue, n.g * _BumpValue, n.b);
            o.Metallic = _Metallic;
            o.Smoothness = _Smoothness + IN.color.b;
            o.Alpha = ground.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
