// Upgrade NOTE: replaced '_Projector' with 'unity_Projector'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/PreviewT4M1" { 
Properties {
_Transp ("Transparency", Range(0,1)) = 1 
_MainTex ("Texture", 2D) = "" { }
_MaskTex ("Mask (RGB) Trans (A)", 2D) = "" { }
}
SubShader {
Pass {
Blend SrcAlpha OneMinusSrcAlpha
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"
struct v2f {
float4 pos : SV_POSITION;
float4 uv : TEXCOORD0;
};
float4x4 unity_Projector;
float _Transp;
sampler2D _MaskTex;
 sampler2D _MainTex;
v2f vert(appdata_base v)
{v2f o;
o.pos = UnityObjectToClipPos(v.vertex);
o.uv = mul(unity_Projector,v.vertex);
return o;
}
half4 frag (v2f i) : SV_Target
{
half4 col =tex2Dproj(_MainTex, UNITY_PROJ_COORD(i.uv));
half4 mask =tex2Dproj (_MaskTex,UNITY_PROJ_COORD(i.uv));
half4 res = col;
res.a = (half)_Transp*mask.a;
return res;
}
ENDCG 
}
}
}		