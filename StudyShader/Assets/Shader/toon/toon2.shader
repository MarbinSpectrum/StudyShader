Shader "Custom/toon2"
{
    Properties
    {
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _NormalMap("NormalMap", 2D) = "bump" {}
        _Level("Level",int) = 10
    }
        SubShader
        {
            Tags { "RenderType" = "Opaque" }
            LOD 200

            cull back

            CGPROGRAM
            #pragma surface surf Toon noambient
            #pragma target 3.0

            sampler2D _MainTex;
            sampler2D _NormalMap;
            int _Level;
            struct Input
            {
                float2 uv_MainTex;
                float2 uv_NormalMap;
            };

            void surf(Input IN, inout SurfaceOutput o)
            {
                fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
                o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));
                o.Albedo = c.rgb;
                o.Alpha = c.a;
            }

            float4 LightingToon(SurfaceOutput s, float3 lightDir,float3 viewDir, float atten)
            {
                float4 final;
                float ndotl = dot(s.Normal, lightDir) * 0.5 + 0.5;
                ndotl *= _Level;
                ndotl = ceil(ndotl) / _Level;
                final.rgb = ndotl * s.Albedo * _LightColor0.rgb;
                final.a = s.Alpha;

                float rim = abs(dot(s.Normal, viewDir));
                if (rim < 0.3)
                    final.rgb = 0;

                return final;
            }

            ENDCG
        }
            FallBack "Diffuse"
}
