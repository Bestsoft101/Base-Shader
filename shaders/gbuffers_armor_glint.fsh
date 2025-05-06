#version 120
#include "fog.glsl"

uniform sampler2D texture;
uniform int fogShape;

varying vec2 texcoord;
varying vec4 color;

void main() {
	gl_FragData[0] = texture2D(texture, texcoord) * color * vec4(vec3(0.75), 1.0);
}