#include "base_noise.glsl"

void main()
{
    float time = iGlobalTime * 1.0;
    vec2 uv = (gl_FragCoord.xy / iResolution.xy);
    uv.y = 1.0 - uv.y;
    vec2 awUV = apsectAwareUV(uv, iResolution.xy);
    vec2 coord = uv2coord(uv);

    vec2 xy = uv2coord(awUV);
    
    float noiseScale = 6.0;
    float noise1 = noise2d(iGlobalTime + noiseScale * xy, cubic);
    float noise2 = noise2d(iGlobalTime + noiseScale * xy + vec2(5438.2353, 123.3458909), cubic);

    mat3 m = mat3(1.0);
    // m *= translate(2.0 * vec2(noise1, noise2) - 1.0);
    // m *= rotate(noise1);
    // m = rotate(iGlobalTime * 0.5);

    vec2 pos = (m * vec3(xy, 1)).xy;

    float angle = atan3(pos.y, pos.x) / TWO_PI;
    float radius = 0.5;
    // radius += (2.0 * noise1 - 1.0) * 0.1;
    // radius += rand1(angle) * 0.5 * sin(iGlobalTime);
    // radius += sin(TWO_PI * 16.0 * angle) * 0.1 * noise1d(angle + iGlobalTime * 0.5, cubic);
    // radius += noise1d(angle * 19.34, cubic) * 0.1 * sin(TWO_PI * angle);
    // radius += angle;
    float sd1 = sdCircle(radius, pos);
    float sd2 = sdCircle(radius - 0.01, pos);

    float d = 0.0055;
    float value = smoothstep(-d, +d, sd1);
    value += 1.0 - smoothstep(-d, +d, sd2);

    gl_FragColor = vec4(vec3(value), 1);
}