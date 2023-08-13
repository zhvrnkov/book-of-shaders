#include "base_noise.glsl"

void main()
{
    float time = iGlobalTime * 1.0;
    vec2 uv = (gl_FragCoord.xy / iResolution.xy);
    uv.y = 1.0 - uv.y;
    vec2 awUV = apsectAwareUV(uv, iResolution.xy);
    vec2 coord = uv2coord(uv);
    vec3 color;

    // mat2 M = rotate2d(-PI / 4.0);
    vec2 xy = uv * 1.0;
    // vec2 f = fract(xy);

    // color.rg = f;

    // color = mix(vec3(1, 0, 0), vec3(0, 1, 0), float(f.x > f.y));

    float n = 2.0;
    float F = (sqrt(n + 1.0) - 1.0) / n;

    float x = xy.x;
    float y = xy.y;

    float x1 = xy.x + (xy.x + xy.y) * F;
    float y1 = xy.y + (xy.x + xy.y) * F;

    float x1b = floor(x1);
    float y1b = floor(y1);

    color = mix(vec3(1, 0, 0), vec3(0, 1, 0), float(x1 > y1));

    gl_FragColor = vec4(color, 1);
}