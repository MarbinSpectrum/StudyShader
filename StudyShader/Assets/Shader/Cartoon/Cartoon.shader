Shader "Custom/Cartoon"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Level("Level",int) = 10
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Test
        #pragma target 3.0

        sampler2D _MainTex;
        int _Level;
        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _Color;

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }

        float4 LightingTest(SurfaceOutput s, float3 lightDir, float atten)
        {
            float ndotl = dot(s.Normal, lightDir);

            ndotl *= _Level;
            ndotl = ceil(ndotl);
            ndotl = ndotl / _Level;
            float4 final;
            final.rgb = ndotl * s.Albedo * _LightColor0.rgb * atten;
            final.a = s.Alpha;
            return final;
        }

        ENDCG
    }
    FallBack "Diffuse"
}
