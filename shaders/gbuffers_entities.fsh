#version 120
#include "/fog.glsl"

#define WORLD_FOG

uniform sampler2D texture;

uniform int fogShape;

uniform vec4 entityColor;

varying vec2 texcoord;
varying vec4 color;

void main() {
	vec4 albedo = texture2D(texture, texcoord) * color;
	
	albedo.rgb = mix(albedo.rgb, entityColor.rgb * color.rgb, entityColor.a);
	
	#ifdef WORLD_FOG
	albedo.rgb = mix(albedo.rgb, gl_Fog.color.rgb, getFogStrength(fogShape, gl_Fog.start, gl_Fog.end));
	#endif
	
	gl_FragData[0] = albedo;
}