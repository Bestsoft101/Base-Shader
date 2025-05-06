#version 120
#include "/fog.glsl"

#define CLOUD_FOG

uniform sampler2D texture;

uniform int fogShape;

varying vec2 texcoord;
varying vec4 color;

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