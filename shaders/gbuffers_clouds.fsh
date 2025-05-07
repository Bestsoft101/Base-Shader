#version 120

#define CLOUD_FOG

uniform sampler2D texture;

uniform float viewWidth;
uniform float viewHeight;

uniform int fogShape;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;

varying vec2 texcoord;
varying vec4 color;

#ifdef CLOUD_FOG
#include "fog.glsl"
#endif

void main() {
	vec4 col = color;
	
	#ifdef CLOUD_FOG
	float width = gl_Fog.end - gl_Fog.start;
	float newWidth = width * 4.0f;
	
	col.a *= 1.0f - getFogStrength(0, gl_Fog.start, gl_Fog.start + newWidth);
	col.rgb = mix(col.rgb, gl_Fog.color.rgb, 0.3f);
	#endif
	
	gl_FragData[0] = texture2D(texture, texcoord) * col;
}