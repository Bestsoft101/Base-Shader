#version 120

#define WORLD_FOG
#define MIPMAP_TYPE 0 // [0 1 2]

uniform sampler2D texture;

uniform float viewWidth;
uniform float viewHeight;

uniform int fogShape;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;

varying vec2 texcoord;
varying vec4 color;

flat varying int id;

#ifdef WORLD_FOG
#include "fog.glsl"
#endif

void main() {
	#if MIPMAP_TYPE == 0
	vec4 albedo = id == 10000 ?
		  texture2D(texture, texcoord) * color
		: texture2DLod(texture, texcoord, 0.0f) * color;
	#elif MIPMAP_TYPE == 1
	vec4 albedo = texture2D(texture, texcoord) * color;
	#elif MIPMAP_TYPE == 2
	vec4 albedo = texture2DLod(texture, texcoord, 0.0f) * color;
	#endif
	
	#ifdef WORLD_FOG
	albedo.rgb = mix(albedo.rgb, gl_Fog.color.rgb, getFogStrength(fogShape, gl_Fog.start, gl_Fog.end));
	#endif
	
	gl_FragData[0] = albedo;
}