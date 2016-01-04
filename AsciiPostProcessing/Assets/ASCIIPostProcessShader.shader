Shader "Custom/ASCIIPostProcessShader" {
	Properties {
		_MainTex ("Main Texture", 2D) = "white" {}
    _AsciiMapTex ("ASCII Map Texture", 2D) = "white" {}
		_AsciiMapCharacterCount ("ASCII Map Character Count", Int) = 7
		
    _tilesX ("X OnScreen Characters", Int) = 160
    _tilesY ("Y OnScreen Characters", Int) = 50
    _tileW ("OnScreen Character Width", Float) = 0.0
    _tileH ("OnScreen Character Height", Float) = 0.0
    _darkness ("Darkness", Float) = 0.0
	}
	SubShader {
		Pass{
			CGPROGRAM
			#pragma fragment frag
			#pragma vertex vert_img
			#pragma target 3.0
			#include "UnityCG.cginc"
			
			struct v2f {
				float4 vertex   : SV_POSITION;
				float2 texcoord : TEXCOORD0;
			};
			
			sampler2D _MainTex;
			
      sampler2D _AsciiMapTex;
			float _AsciiMapCharacterCount;
			
      int _tilesX;
      int _tilesY;
      float _tileW;
      float _tileH;
      float _darkness;
			
			float4 frag(v2f IN) : COLOR {
				fixed4 c = tex2D(_MainTex, IN.texcoord);
				float luminance = clamp(((0.3f * c.r) + (0.59f * c.g) + (0.11f * c.b)) / _darkness, 0.0f, 1.0f);
				
				half2 asciiTexcoord = half2(frac(IN.texcoord.x * (float)_tilesX), frac(IN.texcoord.y * (float)_tilesY));
				asciiTexcoord.x = (asciiTexcoord.x + floor(luminance * (_AsciiMapCharacterCount - 1))) / _AsciiMapCharacterCount;
				fixed4 asciiC = tex2D(_AsciiMapTex, asciiTexcoord);
				
				fixed4 finalC = lerp(c * (luminance + 7.0f) / 10.0f, c, step(0.5f, asciiC.r));
				return finalC;
			}
			ENDCG
		}
	}
	FallBack off
}