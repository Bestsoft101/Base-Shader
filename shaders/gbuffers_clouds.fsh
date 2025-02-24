#version 120

#define FOG

uniform sampler2D texture;

uniform float viewWidth;
uniform float viewHeight;

uniform int fogShape;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;

varying vec2 texcoord;
varying vec4 color;

#ifdef FOG
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
	vec4 col = color;
	
	#ifdef FOG
		float width = gl_Fog.end - gl_Fog.start;
		float newWidth = width * 4.0f;

		col.a *= 1.0f - getFogStrength(0, gl_Fog.start, gl_Fog.start + newWidth);
		col.rgb = mix(col.rgb, gl_Fog.color.rgb, 0.3f);
	#endif
	
	gl_FragData[0] = texture2D(texture, texcoord) * col;
}
