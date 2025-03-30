#version 120

#define WORLD_FOG

uniform sampler2D texture;

uniform float viewWidth;
uniform float viewHeight;

uniform int fogShape;

uniform vec4 entityColor;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;

varying vec2 texcoord;
varying vec4 color;

#ifdef WORLD_FOG

float getFogStrength(int shape, float fogStart, float fogEnd) {
	vec4 fragPos = vec4((gl_FragCoord.xy / vec2(viewWidth, viewHeight)) * 2.0f - 1.0f, gl_FragCoord.z * 2.0f - 1.0f, 1.0f);
	fragPos = gbufferProjectionInverse * fragPos;
	fragPos /= fragPos.w;
	
	float dist;
	if(shape == 1 /* CYLINDER */) {
		vec4 worldPos = gbufferModelViewInverse * fragPos;
		dist = max(length(worldPos.xz), abs(worldPos.y));
	}else {
		dist = length(fragPos.xyz);
	}
	
	return smoothstep(fogStart, fogEnd, dist);
}

#endif

void main() {
	vec4 albedo = texture2D(texture, texcoord) * color;
	
	albedo.rgb = mix(albedo.rgb, entityColor.rgb * color.rgb, entityColor.a);
	
	#ifdef WORLD_FOG
	albedo.rgb = mix(albedo.rgb, gl_Fog.color.rgb, getFogStrength(fogShape, gl_Fog.start, gl_Fog.end));
	#endif
	
	gl_FragData[0] = albedo;
}