
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