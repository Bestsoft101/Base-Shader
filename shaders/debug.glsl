uniform float frameTimeCounter;

// Requires language version 330 or higher.
// "Scrolls" the bytes of a float value like a marquee through the RGB channels of a vec4.
// Best used with PowerToys color picker to visualize the output.
vec4 marqueeFloat(float value, float time, int delay) {
    uint bits = floatBitsToUint(value);

    int step = int(frameTimeCounter / time) % (8 + delay);
	if (step > 7) step = 0;
    int shiftAmount = step * 4;

    uint rotatedBits = (bits << shiftAmount) | (bits >> (32 - shiftAmount));

    float r = float((rotatedBits >> 24) & 0xFFu) / 255.0;
    float g = float((rotatedBits >> 16) & 0xFFu) / 255.0;
    float b = float((rotatedBits >> 8)  & 0xFFu) / 255.0;

    return vec4(r, g, b, 1.0);
}