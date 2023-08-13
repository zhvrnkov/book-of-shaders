#include "base_noise.glsl"

void main()
{
    float time = iGlobalTime * 1.0;
    vec2 uv = (gl_FragCoord.xy / iResolution.xy);
    uv.y = 1.0 - uv.y;
    vec2 awUV = apsectAwareUV(uv, iResolution.xy);
    vec2 coord = uv2coord(uv);

    float scale = 6.0;
    float noise1 = noise2d(iGlobalTime - scale * uv, cubic);
    float noise2 = noise2d(iGlobalTime + scale * uv + vec2(-39.1286, 0.3583), cubic);
    mat3 m = rotate(noise1 * TWO_PI);
    m = translate(vec2(noise1, noise2));

    float noise3 = noise2d(scale * (m * vec3(uv, 1)).xy, cubic);

    float value = noise3;
    gl_FragColor = vec4(vec3(value), 1);
}