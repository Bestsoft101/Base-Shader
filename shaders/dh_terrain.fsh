#version 120

#define DH_ENABLED true
#define FOG

uniform sampler2D texture;
uniform sampler2D depthtex0;

uniform float viewWidth;
uniform float viewHeight;

uniform int fogShape;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;

varying vec2 texcoord;
varying vec4 color;

void main() {
	// Fixes rendering over vanilla terrain rendering.
	vec2 texCoord = gl_FragCoord.xy / vec2(viewWidth, viewHeight);
	float depth = texture(depthtex0, texCoord).r;
	if (depth != 1.0) {
        discard;
	}

	// Proceed with DH rendering.
    vec4 albedo = texture2D(texture, texcoord) * color;


	// Fog Here.


	// Apply color.
	gl_FragData[0] = color;
}
