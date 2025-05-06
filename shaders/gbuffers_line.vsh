#version 120
#extension GL_EXT_gpu_shader4 : enable
//all the messy code in this file is mostly a port of vanilla line rendering.

const float LINE_WIDTH  = 2.5;
const float VIEW_SHRINK = 1.0 - (1.0 / 256.0);
const mat4 VIEW_SCALE   = mat4(
	VIEW_SHRINK, 0.0, 0.0, 0.0,
	0.0, VIEW_SHRINK, 0.0, 0.0,
	0.0, 0.0, VIEW_SHRINK, 0.0,
	0.0, 0.0, 0.0, 1.0
);

uniform float viewHeight;
uniform float viewWidth;
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

in vec3 vaPosition;
in vec3 vaNormal;
in vec4 vaColor;

varying vec4 tint;

void main() {
	vec2 resolution   = vec2(viewWidth, viewHeight);
	vec4 linePosStart = projectionMatrix * (VIEW_SCALE * (modelViewMatrix * vec4(vaPosition, 1.0)));
	vec4 linePosEnd   = projectionMatrix * (VIEW_SCALE * (modelViewMatrix * vec4(vaPosition + vaNormal, 1.0)));

	vec3 ndc1 = linePosStart.xyz / linePosStart.w;
	vec3 ndc2 = linePosEnd.xyz   / linePosEnd.w;

	vec2 lineScreenDirection = normalize((ndc2.xy - ndc1.xy) * resolution);
	vec2 lineOffset = vec2(-lineScreenDirection.y, lineScreenDirection.x) * LINE_WIDTH / resolution;

	if (lineOffset.x < 0.0) lineOffset = -lineOffset;
	if (gl_VertexID % 2 != 0) lineOffset = -lineOffset;
	gl_Position = vec4((ndc1 + vec3(lineOffset, 0.0)) * linePosStart.w, linePosStart.w);

	tint = vaColor;
}