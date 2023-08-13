#include "base_noise.glsl"

void main()
{
    float time = iGlobalTime * 1.0;
    vec2 uv = (gl_FragCoord.xy / iResolution.xy);
    uv.y = 1.0 - uv.y;
    vec2 awUV = apsectAwareUV(uv, iResolution.xy);
    vec2 coord = uv2coord(uv);

    float noise = noise2d(6.0 * uv, cubic);
    float noise2 = noise2d(6.0 * uv + 942.0312, cubic);
    // noise = between2noises(uv / 4.0, cubic, fract(iGlobalTime));
    float maxAngle = PI / 3.0;
    
    float scaleBase = 0.3;
    float scale = 1.0; // scaleBase + noise * (1.0 - scaleBase);

    float angle = 0.0; // maxAngle * noise - maxAngle / 2.0;
    vec2 translation = vec2(noise, noise2) * sin(iGlobalTime);

    mat3 m = srt(vec2(scale), angle, translation);
    vec2 xy = fract((m * vec3(uv, 1)).xy * vec2(16));
    float value = line(xy);
    gl_FragColor = vec4(vec3(value), 1);
}